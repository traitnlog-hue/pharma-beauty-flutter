const allowedOrigins = new Set([
  'http://127.0.0.1:8090',
  'http://localhost:8090',
  'https://pharma-beauty-flutter.web.app',
  'https://pharma-beauty-flutter.firebaseapp.com',
]);

function corsHeaders(request) {
  const origin = request.headers.get('Origin');
  return {
    'Access-Control-Allow-Origin': allowedOrigins.has(origin) ? origin : '',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Content-Type': 'application/json; charset=utf-8',
    'Vary': 'Origin',
  };
}

function pick(record, keys) {
  const normalized = Object.fromEntries(
    Object.entries(record ?? {}).map(([key, value]) => [key.toLowerCase(), value]),
  );
  for (const key of keys) {
    const value = normalized[key.toLowerCase()];
    if (value != null && String(value).trim()) return String(value).trim();
  }
  return '';
}

function findItems(payload) {
  const candidates = [
    payload?.response?.body?.items?.item,
    payload?.response?.body?.items,
    payload?.body?.items?.item,
    payload?.body?.items,
    payload?.items?.item,
    payload?.items,
  ];
  for (const candidate of candidates) {
    if (Array.isArray(candidate)) return candidate;
    if (candidate && typeof candidate === 'object') return [candidate];
  }
  return [];
}

function normalizeIngredient(record) {
  return {
    standardName: pick(record, [
      'INGR_KOR_NAME',
      'stdNm',
      'stdName',
      'standardName',
      '표준명',
    ]),
    englishName: pick(record, [
      'INGR_ENG_NAME',
      'engNm',
      'engName',
      'englishName',
      '영문명',
    ]),
    casNo: pick(record, ['CAS_NO', 'casNo', 'cas', 'casNumber', 'CASNo']),
    originAndDefinition: pick(record, [
      'ORIGIN_MAJOR_KOR_NAME',
      'originAndDefinition',
      'originDef',
      'originDefinition',
      'origin',
      '기원및정의',
    ]),
    aliases: pick(record, [
      'INGR_SYNONYM',
      'alias',
      'aliases',
      'synonym',
      'synonyms',
      '이명',
    ]),
    source: '식품의약품안전처 화장품 원료성분정보',
  };
}

async function searchIngredients(request, env, headers) {
  const url = new URL(request.url);
  const query = url.searchParams.get('q')?.trim();
  if (!query) {
    return Response.json({items: [], source: 'MFDS'}, {headers});
  }
  if (!env.MFDS_COSMETIC_SERVICE_KEY) {
    return Response.json(
      {error: 'Ingredient proxy is not configured'},
      {status: 503, headers},
    );
  }

  const upstream = new URL(
    'https://apis.data.go.kr/1471000/CsmtcsIngdCpntInfoService01/getCsmtcsIngdCpntInfoService01',
  );
  upstream.searchParams.set('pageNo', '1');
  upstream.searchParams.set('numOfRows', '50');
  upstream.searchParams.set('type', 'json');
  // The API's documented standard-name query. The Worker filters again so
  // Korean, INCI, CAS number and aliases produce one consistent result shape.
  upstream.searchParams.set('INGR_KOR_NAME', query);
  upstream.search += `&serviceKey=${env.MFDS_COSMETIC_SERVICE_KEY}`;

  const response = await fetch(upstream);
  if (!response.ok) {
    return Response.json(
      {error: 'MFDS ingredient service is unavailable'},
      {status: 502, headers},
    );
  }
  const payload = await response.json();
  const normalizedQuery = query.toLowerCase();
  const items = findItems(payload)
    .map(normalizeIngredient)
    .filter((item) =>
      [
        item.standardName,
        item.englishName,
        item.casNo,
        item.aliases,
        item.originAndDefinition,
      ]
        .join(' ')
        .toLowerCase()
        .includes(normalizedQuery),
    )
    .slice(0, 12);

  headers['Cache-Control'] = 'public, max-age=3600';
  return Response.json({items, source: 'MFDS'}, {headers});
}

async function getCosmeticsLaw(env, headers) {
  if (!env.LAW_OPEN_API_OC) {
    return Response.json(
      {error: 'Law Open API is not configured'},
      {status: 503, headers},
    );
  }
  const upstream = new URL('https://www.law.go.kr/DRF/lawService.do');
  upstream.searchParams.set('OC', env.LAW_OPEN_API_OC);
  upstream.searchParams.set('target', 'law');
  upstream.searchParams.set('type', 'JSON');
  // 화장품법의 국가법령정보센터 법령 마스터 번호입니다.
  upstream.searchParams.set('MST', '234911');
  const response = await fetch(upstream);
  if (!response.ok) {
    return Response.json(
      {error: 'Korea Law Service is unavailable'},
      {status: 502, headers},
    );
  }
  const law = await response.json();
  headers['Cache-Control'] = 'public, max-age=3600';
  return Response.json(
    {
      source: '국가법령정보 공동활용',
      law,
      officialUrl: 'https://www.law.go.kr/법령/화장품법',
    },
    {headers},
  );
}

// Only catalog product IDs are accepted. The event contains no user, address,
// payment, or device information: it is an anonymous completed-purchase count.
const productIngredients = new Map([
  [1, ['세라마이드', '콜레스테롤', '지방산']],
  [2, ['스쿠알란', '판테놀', '비피다 발효물']],
  [3, ['병풀 추출물', '마데카소사이드', '알란토인']],
  [4, ['BHA', '나이아신아마이드', '판테놀']],
  [5, ['레티날', '스쿠알란', '세라마이드']],
  [6, ['비타민 C', '비타민 E', '페룰릭애씨드']],
]);

function currentKstWeekStart(now = new Date()) {
  const kst = new Date(now.getTime() + 9 * 60 * 60 * 1000);
  const weekdayFromMonday = (kst.getUTCDay() + 6) % 7;
  kst.setUTCDate(kst.getUTCDate() - weekdayFromMonday);
  return kst.toISOString().slice(0, 10);
}

async function recordPurchaseTrend(request, env, headers) {
  if (!env.PURCHASE_TRENDS_DB) {
    return Response.json(
      {error: 'Purchase trend storage is not configured'},
      {status: 503, headers},
    );
  }
  let payload;
  try {
    payload = await request.json();
  } catch (_) {
    return Response.json({error: 'Invalid JSON'}, {status: 400, headers});
  }
  const productIds = [...new Set(
    (Array.isArray(payload?.productIds) ? payload.productIds : [])
      .map(Number)
      .filter((id) => productIngredients.has(id)),
  )].slice(0, 12);
  if (productIds.length === 0) {
    return Response.json({error: 'No catalog products'}, {status: 400, headers});
  }

  const weekStart = currentKstWeekStart();
  const statements = [];
  for (const productId of productIds) {
    statements.push(
      env.PURCHASE_TRENDS_DB.prepare(
        `INSERT INTO weekly_product_purchases
          (week_start, product_id, purchase_count, updated_at)
         VALUES (?, ?, 1, CURRENT_TIMESTAMP)
         ON CONFLICT(week_start, product_id) DO UPDATE SET
          purchase_count = purchase_count + 1,
          updated_at = CURRENT_TIMESTAMP`,
      ).bind(weekStart, productId),
    );
    for (const ingredient of productIngredients.get(productId)) {
      statements.push(
        env.PURCHASE_TRENDS_DB.prepare(
          `INSERT INTO weekly_ingredient_rankings
            (week_start, ingredient, purchase_count, updated_at)
           VALUES (?, ?, 1, CURRENT_TIMESTAMP)
           ON CONFLICT(week_start, ingredient) DO UPDATE SET
            purchase_count = purchase_count + 1,
            updated_at = CURRENT_TIMESTAMP`,
        ).bind(weekStart, ingredient),
      );
    }
  }
  await env.PURCHASE_TRENDS_DB.batch(statements);
  return Response.json({weekStart, recordedProducts: productIds.length}, {headers});
}

async function getWeeklyIngredientRanking(env, headers) {
  if (!env.PURCHASE_TRENDS_DB) {
    return Response.json(
      {error: 'Purchase trend storage is not configured'},
      {status: 503, headers},
    );
  }
  const weekStart = currentKstWeekStart();
  const [ingredients, purchases] = await env.PURCHASE_TRENDS_DB.batch([
    env.PURCHASE_TRENDS_DB.prepare(
      `SELECT ingredient, purchase_count AS purchaseCount
       FROM weekly_ingredient_rankings
       WHERE week_start = ?
       ORDER BY purchase_count DESC, ingredient ASC
       LIMIT 3`,
    ).bind(weekStart),
    env.PURCHASE_TRENDS_DB.prepare(
      `SELECT COALESCE(SUM(purchase_count), 0) AS purchaseCount
       FROM weekly_product_purchases WHERE week_start = ?`,
    ).bind(weekStart),
  ]);
  headers['Cache-Control'] = 'no-store';
  return Response.json(
    {
      weekStart,
      source: 'LEXEM completed purchases',
      totalProductPurchases: purchases.results?.[0]?.purchaseCount ?? 0,
      items: ingredients.results ?? [],
    },
    {headers},
  );
}

export default {
  async fetch(request, env) {
    const headers = corsHeaders(request);
    if (request.method === 'OPTIONS') return new Response(null, {headers});
    if (!['GET', 'POST'].includes(request.method)) {
      return Response.json({error: 'Not found'}, {status: 404, headers});
    }
    if (!headers['Access-Control-Allow-Origin']) {
      return Response.json({error: 'Origin is not allowed'}, {status: 403, headers});
    }
    const path = new URL(request.url).pathname;
    if (path === '/purchase-events' && request.method === 'POST') {
      return recordPurchaseTrend(request, env, headers);
    }
    if (path === '/weekly-ingredient-ranking' && request.method === 'GET') {
      return getWeeklyIngredientRanking(env, headers);
    }
    if (path === '/laws/cosmetics') {
      return getCosmeticsLaw(env, headers);
    }
    if (path === '/ingredients') {
      return searchIngredients(request, env, headers);
    }
    if (path !== '/air-quality') {
      return Response.json({error: 'Not found'}, {status: 404, headers});
    }
    if (!env.AIR_KOREA_SERVICE_KEY) {
      return Response.json({error: 'Proxy is not configured'}, {status: 503, headers});
    }

    const upstream = new URL(
      'https://api.odcloud.kr/api/RltmArpltnInforInqireSvrc/v1/getCtprvnRltmMesureDnsty',
    );
    upstream.searchParams.set('sidoName', '서울');
    upstream.searchParams.set('returnType', 'json');
    upstream.searchParams.set('numOfRows', '1');
    upstream.searchParams.set('pageNo', '1');
    upstream.searchParams.set('ver', '1.3');
    // 공공데이터포털 Encoding 키는 재인코딩하지 않아야 합니다.
    upstream.search += `&serviceKey=${env.AIR_KOREA_SERVICE_KEY}`;

    const response = await fetch(upstream);
    if (!response.ok) {
      return Response.json({error: 'AirKorea is unavailable'}, {status: 502, headers});
    }
    const payload = await response.json();
    const item = payload?.response?.body?.items?.[0];
    if (!item) {
      return Response.json({error: 'No air-quality data'}, {status: 502, headers});
    }

    headers['Cache-Control'] = 'public, max-age=600';
    return Response.json(
      {
        station: item.stationName,
        observedAt: item.dataTime,
        pm25: Number(item.pm25Value),
        airQualityIndex: Number(item.khaiValue),
        airQualityGrade: item.khaiGrade,
        source: 'AirKorea',
      },
      {headers},
    );
  },
};
