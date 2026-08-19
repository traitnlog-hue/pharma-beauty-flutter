class PharmacistChatService {
  const PharmacistChatService();

  static const welcomeMessage =
      '안녕하세요, LEXEM의 레미 AI 약사 챗봇이에요. 피부 고민이나 성분 궁합을 편하게 물어보세요.';

  static const prompts = [
    '성분 궁합 확인',
    '민감 피부 루틴',
    '레티날 사용법',
    '사용 순서',
  ];

  String answerFor(String question) {
    final query = question.toLowerCase();
    if (query.contains('임신') || query.contains('수유')) {
      return '임신·수유 중에는 레티노이드 계열 사용 전 담당 의료진이나 약사에게 먼저 확인해 주세요. 현재 복용약과 피부 상태까지 함께 봐야 안전해요.';
    }
    if (query.contains('레티날') || query.contains('레티놀')) {
      return '레티날은 저녁에 주 2회부터 시작해 보세요. 보습제와 함께 사용하고 다음 날 자외선 차단은 필수예요. 처음에는 BHA와 같은 루틴에서 겹치지 않는 편을 권해요.';
    }
    if (query.contains('bha') || query.contains('살리실')) {
      return 'BHA는 피지와 모공 고민에 잘 맞지만 과사용하면 건조할 수 있어요. 주 2~3회부터 시작하고, 레티노이드와는 날짜를 나눠 사용하는 편이 안전해요.';
    }
    if ((query.contains('비타민 c') || query.contains('비타민c')) &&
        query.contains('나이아신')) {
      return '비타민 C와 나이아신아마이드는 일반적으로 함께 사용할 수 있어요. 민감하다면 아침·저녁으로 나누거나 하나씩 적응시킨 뒤 겹쳐 쓰고, 따가움이 생기면 사용 빈도를 줄여주세요.';
    }
    if (query.contains('비타민 c') || query.contains('비타민c')) {
      return '비타민 C는 보통 아침 세안 후 묽은 제형부터 바르고 보습제와 자외선 차단제로 마무리해요. 산화된 제품은 색과 향이 달라질 수 있으니 보관 상태도 확인해 주세요.';
    }
    if (query.contains('세라마이드') || query.contains('판테놀')) {
      return '세라마이드와 판테놀은 장벽 보습 루틴에 함께 쓰기 좋은 조합이에요. 자극적인 활성 성분을 사용한 날에는 토너 단계를 줄이고 두 성분이 든 보습제로 마무리해 보세요.';
    }
    if (query.contains('순서') || query.contains('아침') || query.contains('저녁')) {
      return '기본 순서는 세안 → 묽은 수분 제품 → 기능성 세럼 → 보습제예요. 아침에는 마지막에 자외선 차단제를, 저녁에는 레티노이드처럼 빛에 민감한 성분을 배치해 주세요.';
    }
    if (query.contains('민감') || query.contains('자극') || query.contains('장벽')) {
      return '민감할 때는 루틴을 세라마이드·판테놀 중심의 세 단계 이내로 줄여보세요. 새 제품은 국소 테스트 후 사용하고, 붉음이나 따가움이 지속되면 사용을 중단해 주세요.';
    }
    if (query.contains('궁합')) {
      return '확인할 두 성분을 알려주세요. 예: “비타민 C와 나이아신아마이드”. 자극 가능성, 사용 순서, 아침·저녁 배치를 함께 정리해 드릴게요.';
    }
    if (query.contains('추천') || query.contains('제품')) {
      return '정확한 추천을 위해 피부 고민, 현재 자극 여부, 선호 제형을 알려주세요. 지금 등록된 피부 프로필을 기준으로도 후보를 좁힐 수 있어요.';
    }
    return '좋은 질문이에요. 피부 고민과 함께 현재 쓰는 성분이나 제품명을 알려주시면, 사용 순서와 함께 더 구체적으로 안내해 드릴게요.';
  }
}
