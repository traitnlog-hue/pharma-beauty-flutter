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
    'Access-Control-Allow-Methods': 'GET, OPTIONS',
    'Content-Type': 'application/json; charset=utf-8',
    'Vary': 'Origin',
  };
}

export default {
  async fetch(request, env) {
    const headers = corsHeaders(request);
    if (request.method === 'OPTIONS') return new Response(null, {headers});
    if (request.method !== 'GET' || new URL(request.url).pathname !== '/air-quality') {
      return Response.json({error: 'Not found'}, {status: 404, headers});
    }
    if (!headers['Access-Control-Allow-Origin']) {
      return Response.json({error: 'Origin is not allowed'}, {status: 403, headers});
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
