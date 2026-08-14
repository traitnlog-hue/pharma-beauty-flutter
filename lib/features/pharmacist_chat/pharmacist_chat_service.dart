class PharmacistChatService {
  const PharmacistChatService();

  static const welcomeMessage =
      '안녕하세요, PHARMA BEAUTY의 리아 약사예요. 피부 고민이나 성분 궁합을 편하게 물어보세요.';

  static const prompts = [
    '성분 궁합 확인',
    '민감 피부 루틴',
    '레티날 사용법',
    '제품 추천',
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
