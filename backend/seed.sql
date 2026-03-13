-- Run this in Supabase SQL Editor
-- Step 1: Metrics
INSERT INTO metrics (code, name, description, is_active, created_at) VALUES
  ('appearance',  '외모',         '외모 및 자기관리',       true, NOW()),
  ('education',   '학력',         '학력 및 지적 수준',       true, NOW()),
  ('income',      '소득',         '경제력 및 재정 상태',     true, NOW()),
  ('family',      '가족',         '가족 관계 및 배경',       true, NOW()),
  ('personality', '성격',         '성격 및 가치관',         true, NOW()),
  ('lifestyle',   '라이프스타일', '생활 패턴 및 취미',       true, NOW())
ON CONFLICT (code) DO NOTHING;

-- Step 2: Questionnaire
INSERT INTO questionnaires (version_no, name, target_gender, is_published, created_at) VALUES
  (1, '결혼 적합도 평가 v1', NULL, true, NOW());

-- Step 3: Questions
INSERT INTO questions (questionnaire_id, metric_id, code, question_text, question_type, display_order, is_required, created_at)
VALUES
  (
    (SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
    (SELECT metric_id FROM metrics WHERE code='appearance'),
    'Q_APP_01', '상대방의 외모 관리에 대해 어떻게 생각하시나요?', 'single_choice', 1, true, NOW()
  ),
  (
    (SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
    (SELECT metric_id FROM metrics WHERE code='education'),
    'Q_EDU_01', '상대방의 학력 수준에 대한 선호는?', 'single_choice', 2, true, NOW()
  ),
  (
    (SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
    (SELECT metric_id FROM metrics WHERE code='income'),
    'Q_INC_01', '상대방의 연 소득 범위에 대한 기대치는?', 'single_choice', 3, true, NOW()
  ),
  (
    (SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
    (SELECT metric_id FROM metrics WHERE code='family'),
    'Q_FAM_01', '가족 관계의 중요성은?', 'single_choice', 4, true, NOW()
  ),
  (
    (SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
    (SELECT metric_id FROM metrics WHERE code='personality'),
    'Q_PER_01', '상대방에게 가장 중요한 성격은?', 'single_choice', 5, true, NOW()
  ),
  (
    (SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
    (SELECT metric_id FROM metrics WHERE code='lifestyle'),
    'Q_LST_01', '주말 생활 패턴의 일치도는 얼마나 중요한가요?', 'single_choice', 6, true, NOW()
  );

-- Step 4: Options for Q_APP_01
INSERT INTO question_options (question_id, option_code, option_text, display_order, created_at) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_APP_01'), 'O_APP_01_A', '매우 중요하다',    1, NOW()),
  ((SELECT question_id FROM questions WHERE code='Q_APP_01'), 'O_APP_01_B', '중요하다',          2, NOW()),
  ((SELECT question_id FROM questions WHERE code='Q_APP_01'), 'O_APP_01_C', '보통이다',          3, NOW()),
  ((SELECT question_id FROM questions WHERE code='Q_APP_01'), 'O_APP_01_D', '중요하지 않다',     4, NOW());

INSERT INTO question_options (question_id, option_code, option_text, display_order, created_at) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_EDU_01'), 'O_EDU_01_A', '대학원 이상', 1, NOW()),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_01'), 'O_EDU_01_B', '대졸',        2, NOW()),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_01'), 'O_EDU_01_C', '전문대졸',    3, NOW()),
  ((SELECT question_id FROM questions WHERE code='Q_EDU_01'), 'O_EDU_01_D', '무관',        4, NOW());

INSERT INTO question_options (question_id, option_code, option_text, display_order, created_at) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_INC_01'), 'O_INC_01_A', '1억 이상',          1, NOW()),
  ((SELECT question_id FROM questions WHERE code='Q_INC_01'), 'O_INC_01_B', '5천~1억',            2, NOW()),
  ((SELECT question_id FROM questions WHERE code='Q_INC_01'), 'O_INC_01_C', '3천~5천',            3, NOW()),
  ((SELECT question_id FROM questions WHERE code='Q_INC_01'), 'O_INC_01_D', '3천 미만도 괜찮다',  4, NOW());

INSERT INTO question_options (question_id, option_code, option_text, display_order, created_at) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_FAM_01'), 'O_FAM_01_A', '매우 중요하다',       1, NOW()),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_01'), 'O_FAM_01_B', '중요하다',             2, NOW()),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_01'), 'O_FAM_01_C', '보통이다',             3, NOW()),
  ((SELECT question_id FROM questions WHERE code='Q_FAM_01'), 'O_FAM_01_D', '별로 중요하지 않다',  4, NOW());

INSERT INTO question_options (question_id, option_code, option_text, display_order, created_at) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_PER_01'), 'O_PER_01_A', '배려심',         1, NOW()),
  ((SELECT question_id FROM questions WHERE code='Q_PER_01'), 'O_PER_01_B', '유머 감각',      2, NOW()),
  ((SELECT question_id FROM questions WHERE code='Q_PER_01'), 'O_PER_01_C', '책임감',         3, NOW()),
  ((SELECT question_id FROM questions WHERE code='Q_PER_01'), 'O_PER_01_D', '긍정적 마인드', 4, NOW());

INSERT INTO question_options (question_id, option_code, option_text, display_order, created_at) VALUES
  ((SELECT question_id FROM questions WHERE code='Q_LST_01'), 'O_LST_01_A', '매우 중요하다',  1, NOW()),
  ((SELECT question_id FROM questions WHERE code='Q_LST_01'), 'O_LST_01_B', '중요하다',        2, NOW()),
  ((SELECT question_id FROM questions WHERE code='Q_LST_01'), 'O_LST_01_C', '보통이다',        3, NOW()),
  ((SELECT question_id FROM questions WHERE code='Q_LST_01'), 'O_LST_01_D', '중요하지 않다',  4, NOW());

-- Step 5: Scoring Rules
INSERT INTO scoring_rules (questionnaire_id, metric_id, question_id, option_id, score, weight)
SELECT
  (SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1),
  q.metric_id,
  q.question_id,
  o.option_id,
  CASE o.display_order
    WHEN 1 THEN 10.0
    WHEN 2 THEN 7.0
    WHEN 3 THEN 4.0
    WHEN 4 THEN 1.0
  END AS score,
  1.0 AS weight
FROM questions q
JOIN question_options o ON o.question_id = q.question_id
WHERE q.questionnaire_id = (SELECT questionnaire_id FROM questionnaires WHERE version_no=1 LIMIT 1);
