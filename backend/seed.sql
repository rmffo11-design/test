-- ============================================================
-- Seed data for Korean marriage compatibility assessment app
-- Run in Supabase SQL Editor
-- ============================================================

TRUNCATE TABLE scoring_rules, question_options, questions, questionnaires, metrics RESTART IDENTITY CASCADE;

-- ============================================================
-- METRICS
-- ============================================================
INSERT INTO metrics (code, name, description, is_active) VALUES
  ('appearance', '외모',        '외모 및 생활 관리',    TRUE),
  ('education',  '학력',        '학력 및 지적 수준',    TRUE),
  ('job',        '직업',        '직업 및 사회적 지위',  TRUE),
  ('income',     '소득',        '경제력 및 연소득',     TRUE),
  ('asset',      '자산',        '개인 자산',            TRUE),
  ('family',     '가족배경',    '가족 환경 및 배경',    TRUE),
  ('personality','성격',        '성격 및 가치관',       TRUE),
  ('lifestyle',  '라이프스타일','생활 패턴 및 취미',    TRUE);

-- ============================================================
-- QUESTIONNAIRE
-- ============================================================
INSERT INTO questionnaires (version_no, name, target_gender, is_published) VALUES
  (1, '결혼 적합도 평가 v1', NULL, TRUE);

-- ============================================================
-- QUESTIONS
-- ============================================================

-- Stage 1: 기본 프로필 (no metric / no scoring)
INSERT INTO questions (questionnaire_id, metric_id, code, question_text, question_type, display_order, is_required)
VALUES
  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1), NULL, 'Q_BASIC_01', '성별',                          'single_choice', 1,  TRUE),
  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1), NULL, 'Q_BASIC_02', '연령대',                        'single_choice', 2,  TRUE),
  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1), NULL, 'Q_BASIC_03', '거주 지역',                     'single_choice', 3,  TRUE),
  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1), NULL, 'Q_BASIC_04', '서울 어느 구에 거주하시나요?',  'single_choice', 4,  TRUE),
  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1), NULL, 'Q_BASIC_05', '혼인 이력',                     'single_choice', 5,  TRUE),
  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1), NULL, 'Q_BASIC_06', '자녀 유무',                     'single_choice', 6,  TRUE),
  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1), NULL, 'Q_BASIC_07', '종교',                          'single_choice', 7,  TRUE);

-- Stage 2: 외모 및 생활 정보
INSERT INTO questions (questionnaire_id, metric_id, code, question_text, question_type, display_order, is_required)
VALUES
  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   NULL,
   'Q_APP_01', '키', 'single_choice', 8, TRUE),

  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   (SELECT metric_id FROM metrics WHERE code='appearance' LIMIT 1),
   'Q_APP_02', '체형', 'single_choice', 9, TRUE),

  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   (SELECT metric_id FROM metrics WHERE code='appearance' LIMIT 1),
   'Q_APP_03', '흡연 여부', 'single_choice', 10, TRUE),

  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   NULL,
   'Q_APP_04', '음주 빈도', 'single_choice', 11, TRUE),

  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   NULL,
   'Q_APP_05', '주거 형태', 'single_choice', 12, TRUE),

  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   NULL,
   'Q_APP_06', '차량 보유', 'single_choice', 13, TRUE);

-- Stage 3: 학력
INSERT INTO questions (questionnaire_id, metric_id, code, question_text, question_type, display_order, is_required)
VALUES
  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   NULL,
   'Q_EDU_01', '최종 학력', 'single_choice', 14, TRUE),

  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   NULL,
   'Q_EDU_02', '학교 구분', 'single_choice', 15, TRUE),

  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   (SELECT metric_id FROM metrics WHERE code='education' LIMIT 1),
   'Q_EDU_03', '출신 학교 등급', 'single_choice', 16, TRUE),

  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   NULL,
   'Q_EDU_04', '전공 계열', 'single_choice', 17, TRUE),

  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   NULL,
   'Q_EDU_05', '졸업 상태', 'single_choice', 18, TRUE);

-- Stage 4: 직업
INSERT INTO questions (questionnaire_id, metric_id, code, question_text, question_type, display_order, is_required)
VALUES
  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   NULL,
   'Q_JOB_01', '직군', 'single_choice', 19, TRUE),

  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   (SELECT metric_id FROM metrics WHERE code='job' LIMIT 1),
   'Q_JOB_02', '직업 등급', 'single_choice', 20, TRUE);

-- Stage 5: 경제력
INSERT INTO questions (questionnaire_id, metric_id, code, question_text, question_type, display_order, is_required)
VALUES
  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   (SELECT metric_id FROM metrics WHERE code='income' LIMIT 1),
   'Q_INC_01', '연소득', 'single_choice', 21, TRUE),

  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   (SELECT metric_id FROM metrics WHERE code='asset' LIMIT 1),
   'Q_ASSET_01', '개인 자산', 'single_choice', 22, TRUE);

-- Stage 6: 가족 배경
INSERT INTO questions (questionnaire_id, metric_id, code, question_text, question_type, display_order, is_required)
VALUES
  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   NULL,
   'Q_FAM_01', '아버지 직업', 'single_choice', 23, TRUE),

  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   NULL,
   'Q_FAM_02', '어머니 직업', 'single_choice', 24, TRUE),

  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   (SELECT metric_id FROM metrics WHERE code='family' LIMIT 1),
   'Q_FAM_03', '부모님 총 자산', 'single_choice', 25, TRUE);

-- Stage 7: 성격 평가
INSERT INTO questions (questionnaire_id, metric_id, code, question_text, question_type, display_order, is_required)
VALUES
  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   (SELECT metric_id FROM metrics WHERE code='personality' LIMIT 1),
   'Q_PER_01', '감정 기복이 적은 편입니다.',             'single_choice', 26, TRUE),

  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   (SELECT metric_id FROM metrics WHERE code='personality' LIMIT 1),
   'Q_PER_02', '책임감이 강한 편입니다.',                'single_choice', 27, TRUE),

  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   (SELECT metric_id FROM metrics WHERE code='personality' LIMIT 1),
   'Q_PER_03', '상대방을 배려하는 편입니다.',            'single_choice', 28, TRUE),

  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   (SELECT metric_id FROM metrics WHERE code='personality' LIMIT 1),
   'Q_PER_04', '약속을 잘 지키는 편입니다.',             'single_choice', 29, TRUE),

  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   (SELECT metric_id FROM metrics WHERE code='personality' LIMIT 1),
   'Q_PER_05', '갈등이 생기면 대화로 해결하려 합니다.', 'single_choice', 30, TRUE);

-- Stage 8: 라이프스타일
INSERT INTO questions (questionnaire_id, metric_id, code, question_text, question_type, display_order, is_required)
VALUES
  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   (SELECT metric_id FROM metrics WHERE code='lifestyle' LIMIT 1),
   'Q_LST_01', '운동 빈도', 'single_choice', 31, TRUE),

  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   (SELECT metric_id FROM metrics WHERE code='lifestyle' LIMIT 1),
   'Q_LST_02', '독서 빈도', 'single_choice', 32, TRUE),

  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   (SELECT metric_id FROM metrics WHERE code='lifestyle' LIMIT 1),
   'Q_LST_03', '소비 성향', 'single_choice', 33, TRUE),

  ((SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
   (SELECT metric_id FROM metrics WHERE code='lifestyle' LIMIT 1),
   'Q_LST_04', '저축 성향', 'single_choice', 34, TRUE);

-- ============================================================
-- OPTIONS
-- ============================================================

-- Q_BASIC_01: 성별
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_01' LIMIT 1), 'O_BASIC_01_A', '남성', 1),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_01' LIMIT 1), 'O_BASIC_01_B', '여성', 2),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_01' LIMIT 1), 'O_BASIC_01_C', '기타', 3);

-- Q_BASIC_02: 연령대
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_02' LIMIT 1), 'O_BASIC_02_A', '20~24세',  1),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_02' LIMIT 1), 'O_BASIC_02_B', '25~29세',  2),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_02' LIMIT 1), 'O_BASIC_02_C', '30~34세',  3),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_02' LIMIT 1), 'O_BASIC_02_D', '35~39세',  4),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_02' LIMIT 1), 'O_BASIC_02_E', '40~44세',  5),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_02' LIMIT 1), 'O_BASIC_02_F', '45~49세',  6),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_02' LIMIT 1), 'O_BASIC_02_G', '50세 이상',7),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_02' LIMIT 1), 'O_BASIC_02_H', '기타',     8);

-- Q_BASIC_03: 거주 지역
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_03' LIMIT 1), 'O_BASIC_03_A', '서울', 1),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_03' LIMIT 1), 'O_BASIC_03_B', '경기', 2),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_03' LIMIT 1), 'O_BASIC_03_C', '인천', 3),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_03' LIMIT 1), 'O_BASIC_03_D', '부산', 4),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_03' LIMIT 1), 'O_BASIC_03_E', '대구', 5),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_03' LIMIT 1), 'O_BASIC_03_F', '대전', 6),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_03' LIMIT 1), 'O_BASIC_03_G', '광주', 7),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_03' LIMIT 1), 'O_BASIC_03_H', '울산', 8),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_03' LIMIT 1), 'O_BASIC_03_I', '세종', 9),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_03' LIMIT 1), 'O_BASIC_03_J', '강원', 10),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_03' LIMIT 1), 'O_BASIC_03_K', '충북', 11),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_03' LIMIT 1), 'O_BASIC_03_L', '충남', 12),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_03' LIMIT 1), 'O_BASIC_03_M', '전북', 13),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_03' LIMIT 1), 'O_BASIC_03_N', '전남', 14),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_03' LIMIT 1), 'O_BASIC_03_O', '경북', 15),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_03' LIMIT 1), 'O_BASIC_03_P', '경남', 16),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_03' LIMIT 1), 'O_BASIC_03_Q', '제주', 17),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_03' LIMIT 1), 'O_BASIC_03_R', '해외', 18),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_03' LIMIT 1), 'O_BASIC_03_S', '기타', 19);

-- Q_BASIC_04: 서울 구 (conditional on Q_BASIC_03 = 서울)
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_A', '강남구',   1),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_B', '강동구',   2),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_C', '강북구',   3),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_D', '강서구',   4),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_E', '관악구',   5),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_F', '광진구',   6),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_G', '구로구',   7),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_H', '금천구',   8),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_I', '노원구',   9),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_J', '도봉구',   10),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_K', '동대문구', 11),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_L', '동작구',   12),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_M', '마포구',   13),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_N', '서대문구', 14),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_O', '서초구',   15),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_P', '성동구',   16),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_Q', '성북구',   17),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_R', '송파구',   18),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_S', '양천구',   19),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_T', '영등포구', 20),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_U', '용산구',   21),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_V', '은평구',   22),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_W', '종로구',   23),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_X', '중구',     24),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_Y', '중랑구',   25),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_04' LIMIT 1), 'O_BASIC_04_Z', '기타',     26);

-- Q_BASIC_05: 혼인 이력
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_05' LIMIT 1), 'O_BASIC_05_A', '미혼', 1),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_05' LIMIT 1), 'O_BASIC_05_B', '이혼', 2),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_05' LIMIT 1), 'O_BASIC_05_C', '사별', 3),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_05' LIMIT 1), 'O_BASIC_05_D', '기타', 4);

-- Q_BASIC_06: 자녀 유무
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_06' LIMIT 1), 'O_BASIC_06_A', '없음', 1),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_06' LIMIT 1), 'O_BASIC_06_B', '있음', 2),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_06' LIMIT 1), 'O_BASIC_06_C', '기타', 3);

-- Q_BASIC_07: 종교
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_07' LIMIT 1), 'O_BASIC_07_A', '무교',   1),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_07' LIMIT 1), 'O_BASIC_07_B', '기독교', 2),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_07' LIMIT 1), 'O_BASIC_07_C', '천주교', 3),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_07' LIMIT 1), 'O_BASIC_07_D', '불교',   4),
  ((SELECT question_id FROM questions WHERE code='Q_BASIC_07' LIMIT 1), 'O_BASIC_07_E', '기타',   5);

-- Q_APP_01: 키
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_APP_01' LIMIT 1), 'O_APP_01_A', '155cm 미만', 1),
  ((SELECT question_id FROM questions WHERE code='Q_APP_01' LIMIT 1), 'O_APP_01_B', '155~160cm',  2),
  ((SELECT question_id FROM questions WHERE code='Q_APP_01' LIMIT 1), 'O_APP_01_C', '160~165cm',  3),
  ((SELECT question_id FROM questions WHERE code='Q_APP_01' LIMIT 1), 'O_APP_01_D', '165~170cm',  4),
  ((SELECT question_id FROM questions WHERE code='Q_APP_01' LIMIT 1), 'O_APP_01_E', '170~175cm',  5),
  ((SELECT question_id FROM questions WHERE code='Q_APP_01' LIMIT 1), 'O_APP_01_F', '175~180cm',  6),
  ((SELECT question_id FROM questions WHERE code='Q_APP_01' LIMIT 1), 'O_APP_01_G', '180~185cm',  7),
  ((SELECT question_id FROM questions WHERE code='Q_APP_01' LIMIT 1), 'O_APP_01_H', '185cm 이상', 8);

-- Q_APP_02: 체형 (scored, metric=appearance)
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_APP_02' LIMIT 1), 'O_APP_02_A', '마른 체형',   1),
  ((SELECT question_id FROM questions WHERE code='Q_APP_02' LIMIT 1), 'O_APP_02_B', '보통 체형',   2),
  ((SELECT question_id FROM questions WHERE code='Q_APP_02' LIMIT 1), 'O_APP_02_C', '근육형',      3),
  ((SELECT question_id FROM questions WHERE code='Q_APP_02' LIMIT 1), 'O_APP_02_D', '통통한 체형', 4),
  ((SELECT question_id FROM questions WHERE code='Q_APP_02' LIMIT 1), 'O_APP_02_E', '기타',        5);

-- Q_APP_03: 흡연 여부 (scored, metric=appearance)
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_APP_03' LIMIT 1), 'O_APP_03_A', '비흡연',   1),
  ((SELECT question_id FROM questions WHERE code='Q_APP_03' LIMIT 1), 'O_APP_03_B', '가끔 흡연',2),
  ((SELECT question_id FROM questions WHERE code='Q_APP_03' LIMIT 1), 'O_APP_03_C', '흡연',     3),
  ((SELECT question_id FROM questions WHERE code='Q_APP_03' LIMIT 1), 'O_APP_03_D', '기타',     4);

-- Q_APP_04: 음주 빈도
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_APP_04' LIMIT 1), 'O_APP_04_A', '하지 않음',  1),
  ((SELECT question_id FROM questions WHERE code='Q_APP_04' LIMIT 1), 'O_APP_04_B', '가끔',       2),
  ((SELECT question_id FROM questions WHERE code='Q_APP_04' LIMIT 1), 'O_APP_04_C', '주 1~2회',   3),
  ((SELECT question_id FROM questions WHERE code='Q_APP_04' LIMIT 1), 'O_APP_04_D', '주 3회 이상',4),
  ((SELECT question_id FROM questions WHERE code='Q_APP_04' LIMIT 1), 'O_APP_04_E', '기타',       5);

-- Q_APP_05: 주거 형태
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_APP_05' LIMIT 1), 'O_APP_05_A', '자가',     1),
  ((SELECT question_id FROM questions WHERE code='Q_APP_05' LIMIT 1), 'O_APP_05_B', '전세',     2),
  ((SELECT question_id FROM questions WHERE code='Q_APP_05' LIMIT 1), 'O_APP_05_C', '월세',     3),
  ((SELECT question_id FROM questions WHERE code='Q_APP_05' LIMIT 1), 'O_APP_05_D', '가족 거주',4),
  ((SELECT question_id FROM questions WHERE code='Q_APP_05' LIMIT 1), 'O_APP_05_E', '기타',     5);

-- Q_APP_06: 차량 보유
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_APP_06' LIMIT 1), 'O_APP_06_A', '없음',   1),
  ((SELECT question_id FROM questions WHERE code='Q_APP_06' LIMIT 1), 'O_APP_06_B', '국산차', 2),
  ((SELECT question_id FROM questions WHERE code='Q_APP_06' LIMIT 1), 'O_APP_06_C', '수입차', 3),
  ((SELECT question_id FROM questions WHERE code='Q_APP_06' LIMIT 1), 'O_APP_06_D', '기타',   4);

-- Q_EDU_01: 최종 학력
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_EDU_01' LIMIT 1), 'O_EDU_01_A', '고등학교',    1),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_01' LIMIT 1), 'O_EDU_01_B', '전문대',      2),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_01' LIMIT 1), 'O_EDU_01_C', '대학교(학사)',3),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_01' LIMIT 1), 'O_EDU_01_D', '석사',        4),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_01' LIMIT 1), 'O_EDU_01_E', '박사',        5),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_01' LIMIT 1), 'O_EDU_01_F', '기타',        6);

-- Q_EDU_02: 학교 구분
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_EDU_02' LIMIT 1), 'O_EDU_02_A', '국내 대학', 1),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_02' LIMIT 1), 'O_EDU_02_B', '해외 대학', 2),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_02' LIMIT 1), 'O_EDU_02_C', '전문대',    3),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_02' LIMIT 1), 'O_EDU_02_D', '고등학교',  4),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_02' LIMIT 1), 'O_EDU_02_E', '기타',      5);

-- Q_EDU_03: 출신 학교 등급 (scored, metric=education)
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_EDU_03' LIMIT 1), 'O_EDU_03_A', '서울대학교(S군)',                     1),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_03' LIMIT 1), 'O_EDU_03_B', '해외 최상위 대학',                   2),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_03' LIMIT 1), 'O_EDU_03_C', '연세대/고려대(A군)',                  3),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_03' LIMIT 1), 'O_EDU_03_D', '서강대/성균관대/한양대(B군)',         4),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_03' LIMIT 1), 'O_EDU_03_E', '해외 상위권 대학',                   5),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_03' LIMIT 1), 'O_EDU_03_F', '중앙대/경희대/외대/시립대/거점 국립대(C군)', 6),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_03' LIMIT 1), 'O_EDU_03_G', '건국대/동국대/홍익대 등 서울권(D군)', 7),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_03' LIMIT 1), 'O_EDU_03_H', '지방 국립대',                        8),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_03' LIMIT 1), 'O_EDU_03_I', '지방 사립대',                        9),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_03' LIMIT 1), 'O_EDU_03_J', '해외 일반 대학',                     10),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_03' LIMIT 1), 'O_EDU_03_K', '전문대(3년제)',                      11),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_03' LIMIT 1), 'O_EDU_03_L', '전문대(2년제)',                      12),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_03' LIMIT 1), 'O_EDU_03_M', '특목고/자사고',                      13),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_03' LIMIT 1), 'O_EDU_03_N', '일반고',                             14),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_03' LIMIT 1), 'O_EDU_03_O', '검정고시',                           15),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_03' LIMIT 1), 'O_EDU_03_P', '기타',                               16);

-- Q_EDU_04: 전공 계열
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_EDU_04' LIMIT 1), 'O_EDU_04_A', '의학 계열', 1),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_04' LIMIT 1), 'O_EDU_04_B', '법학 계열', 2),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_04' LIMIT 1), 'O_EDU_04_C', '공학 계열', 3),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_04' LIMIT 1), 'O_EDU_04_D', '자연과학',  4),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_04' LIMIT 1), 'O_EDU_04_E', '경영/경제', 5),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_04' LIMIT 1), 'O_EDU_04_F', '사회과학',  6),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_04' LIMIT 1), 'O_EDU_04_G', '인문',      7),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_04' LIMIT 1), 'O_EDU_04_H', '예체능',    8),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_04' LIMIT 1), 'O_EDU_04_I', '기타',      9);

-- Q_EDU_05: 졸업 상태
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_EDU_05' LIMIT 1), 'O_EDU_05_A', '졸업',     1),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_05' LIMIT 1), 'O_EDU_05_B', '재학/수료',2),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_05' LIMIT 1), 'O_EDU_05_C', '중퇴',     3),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_05' LIMIT 1), 'O_EDU_05_D', '기타',     4);

-- Q_JOB_01: 직군
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_JOB_01' LIMIT 1), 'O_JOB_01_A', '의료직',           1),
  ((SELECT question_id FROM questions WHERE code='Q_JOB_01' LIMIT 1), 'O_JOB_01_B', '법조직',           2),
  ((SELECT question_id FROM questions WHERE code='Q_JOB_01' LIMIT 1), 'O_JOB_01_C', '금융직',           3),
  ((SELECT question_id FROM questions WHERE code='Q_JOB_01' LIMIT 1), 'O_JOB_01_D', '대기업',           4),
  ((SELECT question_id FROM questions WHERE code='Q_JOB_01' LIMIT 1), 'O_JOB_01_E', '공기업',           5),
  ((SELECT question_id FROM questions WHERE code='Q_JOB_01' LIMIT 1), 'O_JOB_01_F', '공무원',           6),
  ((SELECT question_id FROM questions WHERE code='Q_JOB_01' LIMIT 1), 'O_JOB_01_G', 'IT/테크',          7),
  ((SELECT question_id FROM questions WHERE code='Q_JOB_01' LIMIT 1), 'O_JOB_01_H', '교수/연구직',      8),
  ((SELECT question_id FROM questions WHERE code='Q_JOB_01' LIMIT 1), 'O_JOB_01_I', '사업가/자영업',    9),
  ((SELECT question_id FROM questions WHERE code='Q_JOB_01' LIMIT 1), 'O_JOB_01_J', '예술/엔터테인먼트',10),
  ((SELECT question_id FROM questions WHERE code='Q_JOB_01' LIMIT 1), 'O_JOB_01_K', '프리랜서',         11),
  ((SELECT question_id FROM questions WHERE code='Q_JOB_01' LIMIT 1), 'O_JOB_01_L', '서비스직',         12),
  ((SELECT question_id FROM questions WHERE code='Q_JOB_01' LIMIT 1), 'O_JOB_01_M', '생산/기술직',      13),
  ((SELECT question_id FROM questions WHERE code='Q_JOB_01' LIMIT 1), 'O_JOB_01_N', '기타',             14);

-- Q_JOB_02: 직업 등급 (scored, metric=job)
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_JOB_02' LIMIT 1), 'O_JOB_02_A', 'S 티어 (의사 / 판사·검사 / 대형 로펌 변호사 / 투자은행 / 성공한 기업 대표)', 1),
  ((SELECT question_id FROM questions WHERE code='Q_JOB_02' LIMIT 1), 'O_JOB_02_B', 'A 티어 (변호사 / 치·한의사 / 약사 / 대기업 / 금융권 / 교수 / 고연봉 IT)',     2),
  ((SELECT question_id FROM questions WHERE code='Q_JOB_02' LIMIT 1), 'O_JOB_02_C', 'B 티어 (공기업 / 연구원 / 중견기업 / 개발자 / 교사)',                          3),
  ((SELECT question_id FROM questions WHERE code='Q_JOB_02' LIMIT 1), 'O_JOB_02_D', 'C 티어 (일반 회사원 / 중소기업 / 공무원 / 일반 프리랜서)',                      4),
  ((SELECT question_id FROM questions WHERE code='Q_JOB_02' LIMIT 1), 'O_JOB_02_E', 'D 티어 (서비스직 / 생산직)',                                                    5),
  ((SELECT question_id FROM questions WHERE code='Q_JOB_02' LIMIT 1), 'O_JOB_02_F', 'E 티어 (무직)',                                                                 6),
  ((SELECT question_id FROM questions WHERE code='Q_JOB_02' LIMIT 1), 'O_JOB_02_G', '기타',                                                                          7);

-- Q_INC_01: 연소득 (scored, metric=income)
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_INC_01' LIMIT 1), 'O_INC_01_A', '2천만원 미만', 1),
  ((SELECT question_id FROM questions WHERE code='Q_INC_01' LIMIT 1), 'O_INC_01_B', '2천~4천만원',  2),
  ((SELECT question_id FROM questions WHERE code='Q_INC_01' LIMIT 1), 'O_INC_01_C', '4천~6천만원',  3),
  ((SELECT question_id FROM questions WHERE code='Q_INC_01' LIMIT 1), 'O_INC_01_D', '6천~8천만원',  4),
  ((SELECT question_id FROM questions WHERE code='Q_INC_01' LIMIT 1), 'O_INC_01_E', '8천만원~1억',  5),
  ((SELECT question_id FROM questions WHERE code='Q_INC_01' LIMIT 1), 'O_INC_01_F', '1억~1.5억',    6),
  ((SELECT question_id FROM questions WHERE code='Q_INC_01' LIMIT 1), 'O_INC_01_G', '1.5억~2억',    7),
  ((SELECT question_id FROM questions WHERE code='Q_INC_01' LIMIT 1), 'O_INC_01_H', '2억~3억',      8),
  ((SELECT question_id FROM questions WHERE code='Q_INC_01' LIMIT 1), 'O_INC_01_I', '3억 이상',     9),
  ((SELECT question_id FROM questions WHERE code='Q_INC_01' LIMIT 1), 'O_INC_01_J', '기타',         10);

-- Q_ASSET_01: 개인 자산 (scored, metric=asset)
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_ASSET_01' LIMIT 1), 'O_ASSET_01_A', '1억 미만',  1),
  ((SELECT question_id FROM questions WHERE code='Q_ASSET_01' LIMIT 1), 'O_ASSET_01_B', '1억~3억',   2),
  ((SELECT question_id FROM questions WHERE code='Q_ASSET_01' LIMIT 1), 'O_ASSET_01_C', '3억~5억',   3),
  ((SELECT question_id FROM questions WHERE code='Q_ASSET_01' LIMIT 1), 'O_ASSET_01_D', '5억~10억',  4),
  ((SELECT question_id FROM questions WHERE code='Q_ASSET_01' LIMIT 1), 'O_ASSET_01_E', '10억~20억', 5),
  ((SELECT question_id FROM questions WHERE code='Q_ASSET_01' LIMIT 1), 'O_ASSET_01_F', '20억~50억', 6),
  ((SELECT question_id FROM questions WHERE code='Q_ASSET_01' LIMIT 1), 'O_ASSET_01_G', '50억 이상', 7),
  ((SELECT question_id FROM questions WHERE code='Q_ASSET_01' LIMIT 1), 'O_ASSET_01_H', '기타',      8);

-- Q_FAM_01: 아버지 직업
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_FAM_01' LIMIT 1), 'O_FAM_01_A', '기업 대표',  1),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_01' LIMIT 1), 'O_FAM_01_B', '임원',       2),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_01' LIMIT 1), 'O_FAM_01_C', '의사',       3),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_01' LIMIT 1), 'O_FAM_01_D', '변호사',     4),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_01' LIMIT 1), 'O_FAM_01_E', '판사/검사',  5),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_01' LIMIT 1), 'O_FAM_01_F', '교수',       6),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_01' LIMIT 1), 'O_FAM_01_G', '금융권',     7),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_01' LIMIT 1), 'O_FAM_01_H', '공기업',     8),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_01' LIMIT 1), 'O_FAM_01_I', '공무원',     9),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_01' LIMIT 1), 'O_FAM_01_J', '일반 회사원',10),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_01' LIMIT 1), 'O_FAM_01_K', '자영업',     11),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_01' LIMIT 1), 'O_FAM_01_L', '은퇴',       12),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_01' LIMIT 1), 'O_FAM_01_M', '기타',       13);

-- Q_FAM_02: 어머니 직업
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_FAM_02' LIMIT 1), 'O_FAM_02_A', '기업 대표',  1),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_02' LIMIT 1), 'O_FAM_02_B', '임원',       2),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_02' LIMIT 1), 'O_FAM_02_C', '의사',       3),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_02' LIMIT 1), 'O_FAM_02_D', '변호사',     4),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_02' LIMIT 1), 'O_FAM_02_E', '교수',       5),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_02' LIMIT 1), 'O_FAM_02_F', '금융권',     6),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_02' LIMIT 1), 'O_FAM_02_G', '공기업',     7),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_02' LIMIT 1), 'O_FAM_02_H', '공무원',     8),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_02' LIMIT 1), 'O_FAM_02_I', '일반 회사원',9),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_02' LIMIT 1), 'O_FAM_02_J', '전업주부',   10),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_02' LIMIT 1), 'O_FAM_02_K', '자영업',     11),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_02' LIMIT 1), 'O_FAM_02_L', '기타',       12);

-- Q_FAM_03: 부모님 총 자산 (scored, metric=family)
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_FAM_03' LIMIT 1), 'O_FAM_03_A', '5억 미만',   1),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_03' LIMIT 1), 'O_FAM_03_B', '5억~10억',   2),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_03' LIMIT 1), 'O_FAM_03_C', '10억~20억',  3),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_03' LIMIT 1), 'O_FAM_03_D', '20억~50억',  4),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_03' LIMIT 1), 'O_FAM_03_E', '50억~100억', 5),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_03' LIMIT 1), 'O_FAM_03_F', '100억 이상', 6),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_03' LIMIT 1), 'O_FAM_03_G', '기타',       7);

-- Q_PER_01 ~ Q_PER_05: 성격 (same 5-point scale, metric=personality)
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_PER_01' LIMIT 1), 'O_PER_01_A', '매우 그렇다', 1),
  ((SELECT question_id FROM questions WHERE code='Q_PER_01' LIMIT 1), 'O_PER_01_B', '그렇다',      2),
  ((SELECT question_id FROM questions WHERE code='Q_PER_01' LIMIT 1), 'O_PER_01_C', '보통',        3),
  ((SELECT question_id FROM questions WHERE code='Q_PER_01' LIMIT 1), 'O_PER_01_D', '아니다',      4),
  ((SELECT question_id FROM questions WHERE code='Q_PER_01' LIMIT 1), 'O_PER_01_E', '전혀 아니다', 5);

INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_PER_02' LIMIT 1), 'O_PER_02_A', '매우 그렇다', 1),
  ((SELECT question_id FROM questions WHERE code='Q_PER_02' LIMIT 1), 'O_PER_02_B', '그렇다',      2),
  ((SELECT question_id FROM questions WHERE code='Q_PER_02' LIMIT 1), 'O_PER_02_C', '보통',        3),
  ((SELECT question_id FROM questions WHERE code='Q_PER_02' LIMIT 1), 'O_PER_02_D', '아니다',      4),
  ((SELECT question_id FROM questions WHERE code='Q_PER_02' LIMIT 1), 'O_PER_02_E', '전혀 아니다', 5);

INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_PER_03' LIMIT 1), 'O_PER_03_A', '매우 그렇다', 1),
  ((SELECT question_id FROM questions WHERE code='Q_PER_03' LIMIT 1), 'O_PER_03_B', '그렇다',      2),
  ((SELECT question_id FROM questions WHERE code='Q_PER_03' LIMIT 1), 'O_PER_03_C', '보통',        3),
  ((SELECT question_id FROM questions WHERE code='Q_PER_03' LIMIT 1), 'O_PER_03_D', '아니다',      4),
  ((SELECT question_id FROM questions WHERE code='Q_PER_03' LIMIT 1), 'O_PER_03_E', '전혀 아니다', 5);

INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_PER_04' LIMIT 1), 'O_PER_04_A', '매우 그렇다', 1),
  ((SELECT question_id FROM questions WHERE code='Q_PER_04' LIMIT 1), 'O_PER_04_B', '그렇다',      2),
  ((SELECT question_id FROM questions WHERE code='Q_PER_04' LIMIT 1), 'O_PER_04_C', '보통',        3),
  ((SELECT question_id FROM questions WHERE code='Q_PER_04' LIMIT 1), 'O_PER_04_D', '아니다',      4),
  ((SELECT question_id FROM questions WHERE code='Q_PER_04' LIMIT 1), 'O_PER_04_E', '전혀 아니다', 5);

INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_PER_05' LIMIT 1), 'O_PER_05_A', '매우 그렇다', 1),
  ((SELECT question_id FROM questions WHERE code='Q_PER_05' LIMIT 1), 'O_PER_05_B', '그렇다',      2),
  ((SELECT question_id FROM questions WHERE code='Q_PER_05' LIMIT 1), 'O_PER_05_C', '보통',        3),
  ((SELECT question_id FROM questions WHERE code='Q_PER_05' LIMIT 1), 'O_PER_05_D', '아니다',      4),
  ((SELECT question_id FROM questions WHERE code='Q_PER_05' LIMIT 1), 'O_PER_05_E', '전혀 아니다', 5);

-- Q_LST_01: 운동 빈도 (scored, metric=lifestyle)
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_LST_01' LIMIT 1), 'O_LST_01_A', '매일',     1),
  ((SELECT question_id FROM questions WHERE code='Q_LST_01' LIMIT 1), 'O_LST_01_B', '주 3~4회', 2),
  ((SELECT question_id FROM questions WHERE code='Q_LST_01' LIMIT 1), 'O_LST_01_C', '주 1~2회', 3),
  ((SELECT question_id FROM questions WHERE code='Q_LST_01' LIMIT 1), 'O_LST_01_D', '가끔',     4),
  ((SELECT question_id FROM questions WHERE code='Q_LST_01' LIMIT 1), 'O_LST_01_E', '하지 않음',5);

-- Q_LST_02: 독서 빈도 (scored, metric=lifestyle)
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_LST_02' LIMIT 1), 'O_LST_02_A', '월 4권 이상',1),
  ((SELECT question_id FROM questions WHERE code='Q_LST_02' LIMIT 1), 'O_LST_02_B', '월 1~3권',   2),
  ((SELECT question_id FROM questions WHERE code='Q_LST_02' LIMIT 1), 'O_LST_02_C', '가끔',       3),
  ((SELECT question_id FROM questions WHERE code='Q_LST_02' LIMIT 1), 'O_LST_02_D', '읽지 않음',  4);

-- Q_LST_03: 소비 성향 (scored, metric=lifestyle)
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_LST_03' LIMIT 1), 'O_LST_03_A', '철저히 계획적', 1),
  ((SELECT question_id FROM questions WHERE code='Q_LST_03' LIMIT 1), 'O_LST_03_B', '대체로 계획적', 2),
  ((SELECT question_id FROM questions WHERE code='Q_LST_03' LIMIT 1), 'O_LST_03_C', '보통',          3),
  ((SELECT question_id FROM questions WHERE code='Q_LST_03' LIMIT 1), 'O_LST_03_D', '약간 충동적',   4),
  ((SELECT question_id FROM questions WHERE code='Q_LST_03' LIMIT 1), 'O_LST_03_E', '충동적',        5);

-- Q_LST_04: 저축 성향 (scored, metric=lifestyle)
INSERT INTO question_options (question_id, option_code, option_text, display_order) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_LST_04' LIMIT 1), 'O_LST_04_A', '소득의 50% 이상 저축', 1),
  ((SELECT question_id FROM questions WHERE code='Q_LST_04' LIMIT 1), 'O_LST_04_B', '30~50% 저축',         2),
  ((SELECT question_id FROM questions WHERE code='Q_LST_04' LIMIT 1), 'O_LST_04_C', '10~30% 저축',         3),
  ((SELECT question_id FROM questions WHERE code='Q_LST_04' LIMIT 1), 'O_LST_04_D', '10% 미만 저축',       4),
  ((SELECT question_id FROM questions WHERE code='Q_LST_04' LIMIT 1), 'O_LST_04_E', '저축 안 함',          5);

-- ============================================================
-- SCORING RULES
-- (Only for options that have scores AND belong to a metric)
-- ============================================================

-- Q_APP_02: 체형 (metric=appearance)
INSERT INTO scoring_rules (questionnaire_id, metric_id, question_id, option_id, score, weight)
SELECT
  (SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
  (SELECT metric_id FROM metrics WHERE code='appearance' LIMIT 1),
  (SELECT question_id FROM questions WHERE code='Q_APP_02' LIMIT 1),
  option_id,
  CASE option_code
    WHEN 'O_APP_02_A' THEN 6.0
    WHEN 'O_APP_02_B' THEN 7.0
    WHEN 'O_APP_02_C' THEN 8.0
    WHEN 'O_APP_02_D' THEN 4.0
    WHEN 'O_APP_02_E' THEN 5.0
  END,
  1.0
FROM question_options
WHERE question_id = (SELECT question_id FROM questions WHERE code='Q_APP_02' LIMIT 1);

-- Q_APP_03: 흡연 여부 (metric=appearance)
INSERT INTO scoring_rules (questionnaire_id, metric_id, question_id, option_id, score, weight)
SELECT
  (SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
  (SELECT metric_id FROM metrics WHERE code='appearance' LIMIT 1),
  (SELECT question_id FROM questions WHERE code='Q_APP_03' LIMIT 1),
  option_id,
  CASE option_code
    WHEN 'O_APP_03_A' THEN 2.0
    WHEN 'O_APP_03_B' THEN 1.0
    WHEN 'O_APP_03_C' THEN 0.0
    WHEN 'O_APP_03_D' THEN 1.0
  END,
  1.0
FROM question_options
WHERE question_id = (SELECT question_id FROM questions WHERE code='Q_APP_03' LIMIT 1);

-- Q_EDU_03: 출신 학교 등급 (metric=education)
INSERT INTO scoring_rules (questionnaire_id, metric_id, question_id, option_id, score, weight)
SELECT
  (SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
  (SELECT metric_id FROM metrics WHERE code='education' LIMIT 1),
  (SELECT question_id FROM questions WHERE code='Q_EDU_03' LIMIT 1),
  option_id,
  CASE option_code
    WHEN 'O_EDU_03_A' THEN 15.0
    WHEN 'O_EDU_03_B' THEN 14.0
    WHEN 'O_EDU_03_C' THEN 13.0
    WHEN 'O_EDU_03_D' THEN 11.0
    WHEN 'O_EDU_03_E' THEN 10.0
    WHEN 'O_EDU_03_F' THEN 9.0
    WHEN 'O_EDU_03_G' THEN 7.0
    WHEN 'O_EDU_03_H' THEN 6.0
    WHEN 'O_EDU_03_I' THEN 5.0
    WHEN 'O_EDU_03_J' THEN 4.0
    WHEN 'O_EDU_03_K' THEN 3.0
    WHEN 'O_EDU_03_L' THEN 2.5
    WHEN 'O_EDU_03_M' THEN 2.0
    WHEN 'O_EDU_03_N' THEN 1.5
    WHEN 'O_EDU_03_O' THEN 1.0
    WHEN 'O_EDU_03_P' THEN 4.0
  END,
  1.0
FROM question_options
WHERE question_id = (SELECT question_id FROM questions WHERE code='Q_EDU_03' LIMIT 1);

-- Q_JOB_02: 직업 등급 (metric=job)
INSERT INTO scoring_rules (questionnaire_id, metric_id, question_id, option_id, score, weight)
SELECT
  (SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
  (SELECT metric_id FROM metrics WHERE code='job' LIMIT 1),
  (SELECT question_id FROM questions WHERE code='Q_JOB_02' LIMIT 1),
  option_id,
  CASE option_code
    WHEN 'O_JOB_02_A' THEN 15.0
    WHEN 'O_JOB_02_B' THEN 12.0
    WHEN 'O_JOB_02_C' THEN 9.0
    WHEN 'O_JOB_02_D' THEN 6.0
    WHEN 'O_JOB_02_E' THEN 3.0
    WHEN 'O_JOB_02_F' THEN 0.0
    WHEN 'O_JOB_02_G' THEN 5.0
  END,
  1.0
FROM question_options
WHERE question_id = (SELECT question_id FROM questions WHERE code='Q_JOB_02' LIMIT 1);

-- Q_INC_01: 연소득 (metric=income)
INSERT INTO scoring_rules (questionnaire_id, metric_id, question_id, option_id, score, weight)
SELECT
  (SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
  (SELECT metric_id FROM metrics WHERE code='income' LIMIT 1),
  (SELECT question_id FROM questions WHERE code='Q_INC_01' LIMIT 1),
  option_id,
  CASE option_code
    WHEN 'O_INC_01_A' THEN 1.0
    WHEN 'O_INC_01_B' THEN 3.0
    WHEN 'O_INC_01_C' THEN 5.0
    WHEN 'O_INC_01_D' THEN 7.0
    WHEN 'O_INC_01_E' THEN 9.0
    WHEN 'O_INC_01_F' THEN 11.0
    WHEN 'O_INC_01_G' THEN 12.0
    WHEN 'O_INC_01_H' THEN 13.0
    WHEN 'O_INC_01_I' THEN 15.0
    WHEN 'O_INC_01_J' THEN 3.0
  END,
  1.0
FROM question_options
WHERE question_id = (SELECT question_id FROM questions WHERE code='Q_INC_01' LIMIT 1);

-- Q_ASSET_01: 개인 자산 (metric=asset)
INSERT INTO scoring_rules (questionnaire_id, metric_id, question_id, option_id, score, weight)
SELECT
  (SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
  (SELECT metric_id FROM metrics WHERE code='asset' LIMIT 1),
  (SELECT question_id FROM questions WHERE code='Q_ASSET_01' LIMIT 1),
  option_id,
  CASE option_code
    WHEN 'O_ASSET_01_A' THEN 2.0
    WHEN 'O_ASSET_01_B' THEN 5.0
    WHEN 'O_ASSET_01_C' THEN 7.0
    WHEN 'O_ASSET_01_D' THEN 9.0
    WHEN 'O_ASSET_01_E' THEN 11.0
    WHEN 'O_ASSET_01_F' THEN 13.0
    WHEN 'O_ASSET_01_G' THEN 15.0
    WHEN 'O_ASSET_01_H' THEN 4.0
  END,
  1.0
FROM question_options
WHERE question_id = (SELECT question_id FROM questions WHERE code='Q_ASSET_01' LIMIT 1);

-- Q_FAM_03: 부모님 총 자산 (metric=family)
INSERT INTO scoring_rules (questionnaire_id, metric_id, question_id, option_id, score, weight)
SELECT
  (SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
  (SELECT metric_id FROM metrics WHERE code='family' LIMIT 1),
  (SELECT question_id FROM questions WHERE code='Q_FAM_03' LIMIT 1),
  option_id,
  CASE option_code
    WHEN 'O_FAM_03_A' THEN 4.0
    WHEN 'O_FAM_03_B' THEN 7.0
    WHEN 'O_FAM_03_C' THEN 9.0
    WHEN 'O_FAM_03_D' THEN 11.0
    WHEN 'O_FAM_03_E' THEN 13.0
    WHEN 'O_FAM_03_F' THEN 15.0
    WHEN 'O_FAM_03_G' THEN 4.0
  END,
  1.0
FROM question_options
WHERE question_id = (SELECT question_id FROM questions WHERE code='Q_FAM_03' LIMIT 1);

-- Q_PER_01: 감정 기복 (metric=personality)
INSERT INTO scoring_rules (questionnaire_id, metric_id, question_id, option_id, score, weight)
SELECT
  (SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
  (SELECT metric_id FROM metrics WHERE code='personality' LIMIT 1),
  (SELECT question_id FROM questions WHERE code='Q_PER_01' LIMIT 1),
  option_id,
  CASE option_code
    WHEN 'O_PER_01_A' THEN 2.0
    WHEN 'O_PER_01_B' THEN 1.5
    WHEN 'O_PER_01_C' THEN 1.0
    WHEN 'O_PER_01_D' THEN 0.5
    WHEN 'O_PER_01_E' THEN 0.0
  END,
  1.0
FROM question_options
WHERE question_id = (SELECT question_id FROM questions WHERE code='Q_PER_01' LIMIT 1);

-- Q_PER_02: 책임감 (metric=personality)
INSERT INTO scoring_rules (questionnaire_id, metric_id, question_id, option_id, score, weight)
SELECT
  (SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
  (SELECT metric_id FROM metrics WHERE code='personality' LIMIT 1),
  (SELECT question_id FROM questions WHERE code='Q_PER_02' LIMIT 1),
  option_id,
  CASE option_code
    WHEN 'O_PER_02_A' THEN 2.0
    WHEN 'O_PER_02_B' THEN 1.5
    WHEN 'O_PER_02_C' THEN 1.0
    WHEN 'O_PER_02_D' THEN 0.5
    WHEN 'O_PER_02_E' THEN 0.0
  END,
  1.0
FROM question_options
WHERE question_id = (SELECT question_id FROM questions WHERE code='Q_PER_02' LIMIT 1);

-- Q_PER_03: 배려 (metric=personality)
INSERT INTO scoring_rules (questionnaire_id, metric_id, question_id, option_id, score, weight)
SELECT
  (SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
  (SELECT metric_id FROM metrics WHERE code='personality' LIMIT 1),
  (SELECT question_id FROM questions WHERE code='Q_PER_03' LIMIT 1),
  option_id,
  CASE option_code
    WHEN 'O_PER_03_A' THEN 2.0
    WHEN 'O_PER_03_B' THEN 1.5
    WHEN 'O_PER_03_C' THEN 1.0
    WHEN 'O_PER_03_D' THEN 0.5
    WHEN 'O_PER_03_E' THEN 0.0
  END,
  1.0
FROM question_options
WHERE question_id = (SELECT question_id FROM questions WHERE code='Q_PER_03' LIMIT 1);

-- Q_PER_04: 약속 (metric=personality)
INSERT INTO scoring_rules (questionnaire_id, metric_id, question_id, option_id, score, weight)
SELECT
  (SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
  (SELECT metric_id FROM metrics WHERE code='personality' LIMIT 1),
  (SELECT question_id FROM questions WHERE code='Q_PER_04' LIMIT 1),
  option_id,
  CASE option_code
    WHEN 'O_PER_04_A' THEN 2.0
    WHEN 'O_PER_04_B' THEN 1.5
    WHEN 'O_PER_04_C' THEN 1.0
    WHEN 'O_PER_04_D' THEN 0.5
    WHEN 'O_PER_04_E' THEN 0.0
  END,
  1.0
FROM question_options
WHERE question_id = (SELECT question_id FROM questions WHERE code='Q_PER_04' LIMIT 1);

-- Q_PER_05: 갈등 해결 (metric=personality)
INSERT INTO scoring_rules (questionnaire_id, metric_id, question_id, option_id, score, weight)
SELECT
  (SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
  (SELECT metric_id FROM metrics WHERE code='personality' LIMIT 1),
  (SELECT question_id FROM questions WHERE code='Q_PER_05' LIMIT 1),
  option_id,
  CASE option_code
    WHEN 'O_PER_05_A' THEN 2.0
    WHEN 'O_PER_05_B' THEN 1.5
    WHEN 'O_PER_05_C' THEN 1.0
    WHEN 'O_PER_05_D' THEN 0.5
    WHEN 'O_PER_05_E' THEN 0.0
  END,
  1.0
FROM question_options
WHERE question_id = (SELECT question_id FROM questions WHERE code='Q_PER_05' LIMIT 1);

-- Q_LST_01: 운동 빈도 (metric=lifestyle)
INSERT INTO scoring_rules (questionnaire_id, metric_id, question_id, option_id, score, weight)
SELECT
  (SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
  (SELECT metric_id FROM metrics WHERE code='lifestyle' LIMIT 1),
  (SELECT question_id FROM questions WHERE code='Q_LST_01' LIMIT 1),
  option_id,
  CASE option_code
    WHEN 'O_LST_01_A' THEN 2.0
    WHEN 'O_LST_01_B' THEN 1.5
    WHEN 'O_LST_01_C' THEN 1.0
    WHEN 'O_LST_01_D' THEN 0.5
    WHEN 'O_LST_01_E' THEN 0.0
  END,
  1.0
FROM question_options
WHERE question_id = (SELECT question_id FROM questions WHERE code='Q_LST_01' LIMIT 1);

-- Q_LST_02: 독서 빈도 (metric=lifestyle)
INSERT INTO scoring_rules (questionnaire_id, metric_id, question_id, option_id, score, weight)
SELECT
  (SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
  (SELECT metric_id FROM metrics WHERE code='lifestyle' LIMIT 1),
  (SELECT question_id FROM questions WHERE code='Q_LST_02' LIMIT 1),
  option_id,
  CASE option_code
    WHEN 'O_LST_02_A' THEN 1.0
    WHEN 'O_LST_02_B' THEN 0.7
    WHEN 'O_LST_02_C' THEN 0.3
    WHEN 'O_LST_02_D' THEN 0.0
  END,
  1.0
FROM question_options
WHERE question_id = (SELECT question_id FROM questions WHERE code='Q_LST_02' LIMIT 1);

-- Q_LST_03: 소비 성향 (metric=lifestyle)
INSERT INTO scoring_rules (questionnaire_id, metric_id, question_id, option_id, score, weight)
SELECT
  (SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
  (SELECT metric_id FROM metrics WHERE code='lifestyle' LIMIT 1),
  (SELECT question_id FROM questions WHERE code='Q_LST_03' LIMIT 1),
  option_id,
  CASE option_code
    WHEN 'O_LST_03_A' THEN 1.0
    WHEN 'O_LST_03_B' THEN 0.8
    WHEN 'O_LST_03_C' THEN 0.5
    WHEN 'O_LST_03_D' THEN 0.2
    WHEN 'O_LST_03_E' THEN 0.0
  END,
  1.0
FROM question_options
WHERE question_id = (SELECT question_id FROM questions WHERE code='Q_LST_03' LIMIT 1);

-- Q_LST_04: 저축 성향 (metric=lifestyle)
INSERT INTO scoring_rules (questionnaire_id, metric_id, question_id, option_id, score, weight)
SELECT
  (SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
  (SELECT metric_id FROM metrics WHERE code='lifestyle' LIMIT 1),
  (SELECT question_id FROM questions WHERE code='Q_LST_04' LIMIT 1),
  option_id,
  CASE option_code
    WHEN 'O_LST_04_A' THEN 1.0
    WHEN 'O_LST_04_B' THEN 0.8
    WHEN 'O_LST_04_C' THEN 0.5
    WHEN 'O_LST_04_D' THEN 0.2
    WHEN 'O_LST_04_E' THEN 0.0
  END,
  1.0
FROM question_options
WHERE question_id = (SELECT question_id FROM questions WHERE code='Q_LST_04' LIMIT 1);
