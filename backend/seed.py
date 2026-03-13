"""
Seed script — inserts metrics, questionnaire, questions, options, and scoring rules
for the Korean marriage compatibility assessment app.

Usage (from backend/):
    python seed.py
"""
import asyncio
import os

from dotenv import load_dotenv
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine

load_dotenv()

DATABASE_URL = os.environ["DATABASE_URL"]

_connect_args: dict = {}
if "supabase" in DATABASE_URL:
    _connect_args["ssl"] = "require"
if ":6543" in DATABASE_URL:  # Transaction Pooler: disable prepared statement cache
    _connect_args["statement_cache_size"] = 0

engine = create_async_engine(DATABASE_URL, echo=False, connect_args=_connect_args)
AsyncSessionLocal = async_sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)

# Import models after engine is ready
import app.models  # noqa: F401, E402
from app.models import (  # noqa: E402
    Metric,
    Questionnaire,
    Question,
    QuestionOption,
    ScoringRule,
)
from app.core.db import Base  # noqa: E402


METRICS = [
    {"code": "appearance", "name": "외모", "description": "외모 및 생활 관리"},
    {"code": "education", "name": "학력", "description": "학력 및 지적 수준"},
    {"code": "job", "name": "직업", "description": "직업 및 사회적 지위"},
    {"code": "income", "name": "소득", "description": "경제력 및 연소득"},
    {"code": "asset", "name": "자산", "description": "개인 자산"},
    {"code": "family", "name": "가족배경", "description": "가족 환경 및 배경"},
    {"code": "personality", "name": "성격", "description": "성격 및 가치관"},
    {"code": "lifestyle", "name": "라이프스타일", "description": "생활 패턴 및 취미"},
]

# Each question dict:
#   code, stage, text, type, order, metric_code (None = no scoring), options list
#   Each option: code, text, and optionally score (float). No score key = no ScoringRule.
QUESTIONS = [
    # ── Stage 1: 기본 프로필 ──────────────────────────────────────────────────
    {
        "stage": 1,
        "code": "Q_BASIC_01",
        "text": "성별",
        "type": "single_choice",
        "order": 1,
        "metric_code": None,
        "options": [
            {"code": "O_BASIC_01_A", "text": "남성"},
            {"code": "O_BASIC_01_B", "text": "여성"},
            {"code": "O_BASIC_01_C", "text": "기타"},
        ],
    },
    {
        "stage": 1,
        "code": "Q_BASIC_02",
        "text": "연령대",
        "type": "single_choice",
        "order": 2,
        "metric_code": None,
        "options": [
            {"code": "O_BASIC_02_A", "text": "20~24세"},
            {"code": "O_BASIC_02_B", "text": "25~29세"},
            {"code": "O_BASIC_02_C", "text": "30~34세"},
            {"code": "O_BASIC_02_D", "text": "35~39세"},
            {"code": "O_BASIC_02_E", "text": "40~44세"},
            {"code": "O_BASIC_02_F", "text": "45~49세"},
            {"code": "O_BASIC_02_G", "text": "50세 이상"},
            {"code": "O_BASIC_02_H", "text": "기타"},
        ],
    },
    {
        "stage": 1,
        "code": "Q_BASIC_03",
        "text": "거주 지역",
        "type": "single_choice",
        "order": 3,
        "metric_code": None,
        "options": [
            {"code": "O_BASIC_03_A", "text": "서울"},
            {"code": "O_BASIC_03_B", "text": "경기"},
            {"code": "O_BASIC_03_C", "text": "인천"},
            {"code": "O_BASIC_03_D", "text": "부산"},
            {"code": "O_BASIC_03_E", "text": "대구"},
            {"code": "O_BASIC_03_F", "text": "대전"},
            {"code": "O_BASIC_03_G", "text": "광주"},
            {"code": "O_BASIC_03_H", "text": "울산"},
            {"code": "O_BASIC_03_I", "text": "세종"},
            {"code": "O_BASIC_03_J", "text": "강원"},
            {"code": "O_BASIC_03_K", "text": "충북"},
            {"code": "O_BASIC_03_L", "text": "충남"},
            {"code": "O_BASIC_03_M", "text": "전북"},
            {"code": "O_BASIC_03_N", "text": "전남"},
            {"code": "O_BASIC_03_O", "text": "경북"},
            {"code": "O_BASIC_03_P", "text": "경남"},
            {"code": "O_BASIC_03_Q", "text": "제주"},
            {"code": "O_BASIC_03_R", "text": "해외"},
            {"code": "O_BASIC_03_S", "text": "기타"},
        ],
    },
    {
        "stage": 1,
        "code": "Q_BASIC_04",
        "text": "서울 어느 구에 거주하시나요?",
        "type": "single_choice",
        "order": 4,
        "metric_code": None,
        "conditional_on": "Q_BASIC_03",
        "conditional_value": "서울",
        "options": [
            {"code": "O_BASIC_04_A", "text": "강남구"},
            {"code": "O_BASIC_04_B", "text": "강동구"},
            {"code": "O_BASIC_04_C", "text": "강북구"},
            {"code": "O_BASIC_04_D", "text": "강서구"},
            {"code": "O_BASIC_04_E", "text": "관악구"},
            {"code": "O_BASIC_04_F", "text": "광진구"},
            {"code": "O_BASIC_04_G", "text": "구로구"},
            {"code": "O_BASIC_04_H", "text": "금천구"},
            {"code": "O_BASIC_04_I", "text": "노원구"},
            {"code": "O_BASIC_04_J", "text": "도봉구"},
            {"code": "O_BASIC_04_K", "text": "동대문구"},
            {"code": "O_BASIC_04_L", "text": "동작구"},
            {"code": "O_BASIC_04_M", "text": "마포구"},
            {"code": "O_BASIC_04_N", "text": "서대문구"},
            {"code": "O_BASIC_04_O", "text": "서초구"},
            {"code": "O_BASIC_04_P", "text": "성동구"},
            {"code": "O_BASIC_04_Q", "text": "성북구"},
            {"code": "O_BASIC_04_R", "text": "송파구"},
            {"code": "O_BASIC_04_S", "text": "양천구"},
            {"code": "O_BASIC_04_T", "text": "영등포구"},
            {"code": "O_BASIC_04_U", "text": "용산구"},
            {"code": "O_BASIC_04_V", "text": "은평구"},
            {"code": "O_BASIC_04_W", "text": "종로구"},
            {"code": "O_BASIC_04_X", "text": "중구"},
            {"code": "O_BASIC_04_Y", "text": "중랑구"},
            {"code": "O_BASIC_04_Z", "text": "기타"},
        ],
    },
    {
        "stage": 1,
        "code": "Q_BASIC_05",
        "text": "혼인 이력",
        "type": "single_choice",
        "order": 5,
        "metric_code": None,
        "options": [
            {"code": "O_BASIC_05_A", "text": "미혼"},
            {"code": "O_BASIC_05_B", "text": "이혼"},
            {"code": "O_BASIC_05_C", "text": "사별"},
            {"code": "O_BASIC_05_D", "text": "기타"},
        ],
    },
    {
        "stage": 1,
        "code": "Q_BASIC_06",
        "text": "자녀 유무",
        "type": "single_choice",
        "order": 6,
        "metric_code": None,
        "options": [
            {"code": "O_BASIC_06_A", "text": "없음"},
            {"code": "O_BASIC_06_B", "text": "있음"},
            {"code": "O_BASIC_06_C", "text": "기타"},
        ],
    },
    {
        "stage": 1,
        "code": "Q_BASIC_07",
        "text": "종교",
        "type": "single_choice",
        "order": 7,
        "metric_code": None,
        "options": [
            {"code": "O_BASIC_07_A", "text": "무교"},
            {"code": "O_BASIC_07_B", "text": "기독교"},
            {"code": "O_BASIC_07_C", "text": "천주교"},
            {"code": "O_BASIC_07_D", "text": "불교"},
            {"code": "O_BASIC_07_E", "text": "기타"},
        ],
    },
    # ── Stage 2: 외모 및 생활 정보 ────────────────────────────────────────────
    {
        "stage": 2,
        "code": "Q_APP_01",
        "text": "키",
        "type": "single_choice",
        "order": 8,
        "metric_code": None,
        "options": [
            {"code": "O_APP_01_A", "text": "155cm 미만"},
            {"code": "O_APP_01_B", "text": "155~160cm"},
            {"code": "O_APP_01_C", "text": "160~165cm"},
            {"code": "O_APP_01_D", "text": "165~170cm"},
            {"code": "O_APP_01_E", "text": "170~175cm"},
            {"code": "O_APP_01_F", "text": "175~180cm"},
            {"code": "O_APP_01_G", "text": "180~185cm"},
            {"code": "O_APP_01_H", "text": "185cm 이상"},
        ],
    },
    {
        "stage": 2,
        "code": "Q_APP_02",
        "text": "체형",
        "type": "single_choice",
        "order": 9,
        "metric_code": "appearance",
        "options": [
            {"code": "O_APP_02_A", "text": "마른 체형", "score": 6},
            {"code": "O_APP_02_B", "text": "보통 체형", "score": 7},
            {"code": "O_APP_02_C", "text": "근육형", "score": 8},
            {"code": "O_APP_02_D", "text": "통통한 체형", "score": 4},
            {"code": "O_APP_02_E", "text": "기타", "score": 5},
        ],
    },
    {
        "stage": 2,
        "code": "Q_APP_03",
        "text": "흡연 여부",
        "type": "single_choice",
        "order": 10,
        "metric_code": "appearance",
        "options": [
            {"code": "O_APP_03_A", "text": "비흡연", "score": 2},
            {"code": "O_APP_03_B", "text": "가끔 흡연", "score": 1},
            {"code": "O_APP_03_C", "text": "흡연", "score": 0},
            {"code": "O_APP_03_D", "text": "기타", "score": 1},
        ],
    },
    {
        "stage": 2,
        "code": "Q_APP_04",
        "text": "음주 빈도",
        "type": "single_choice",
        "order": 11,
        "metric_code": None,
        "options": [
            {"code": "O_APP_04_A", "text": "하지 않음"},
            {"code": "O_APP_04_B", "text": "가끔"},
            {"code": "O_APP_04_C", "text": "주 1~2회"},
            {"code": "O_APP_04_D", "text": "주 3회 이상"},
            {"code": "O_APP_04_E", "text": "기타"},
        ],
    },
    {
        "stage": 2,
        "code": "Q_APP_05",
        "text": "주거 형태",
        "type": "single_choice",
        "order": 12,
        "metric_code": None,
        "options": [
            {"code": "O_APP_05_A", "text": "자가"},
            {"code": "O_APP_05_B", "text": "전세"},
            {"code": "O_APP_05_C", "text": "월세"},
            {"code": "O_APP_05_D", "text": "가족 거주"},
            {"code": "O_APP_05_E", "text": "기타"},
        ],
    },
    {
        "stage": 2,
        "code": "Q_APP_06",
        "text": "차량 보유",
        "type": "single_choice",
        "order": 13,
        "metric_code": None,
        "options": [
            {"code": "O_APP_06_A", "text": "없음"},
            {"code": "O_APP_06_B", "text": "국산차"},
            {"code": "O_APP_06_C", "text": "수입차"},
            {"code": "O_APP_06_D", "text": "기타"},
        ],
    },
    # ── Stage 3: 학력 ─────────────────────────────────────────────────────────
    {
        "stage": 3,
        "code": "Q_EDU_01",
        "text": "최종 학력",
        "type": "single_choice",
        "order": 14,
        "metric_code": None,
        "options": [
            {"code": "O_EDU_01_A", "text": "고등학교"},
            {"code": "O_EDU_01_B", "text": "전문대"},
            {"code": "O_EDU_01_C", "text": "대학교(학사)"},
            {"code": "O_EDU_01_D", "text": "석사"},
            {"code": "O_EDU_01_E", "text": "박사"},
            {"code": "O_EDU_01_F", "text": "기타"},
        ],
    },
    {
        "stage": 3,
        "code": "Q_EDU_02",
        "text": "학교 구분",
        "type": "single_choice",
        "order": 15,
        "metric_code": None,
        "options": [
            {"code": "O_EDU_02_A", "text": "국내 대학"},
            {"code": "O_EDU_02_B", "text": "해외 대학"},
            {"code": "O_EDU_02_C", "text": "전문대"},
            {"code": "O_EDU_02_D", "text": "고등학교"},
            {"code": "O_EDU_02_E", "text": "기타"},
        ],
    },
    {
        "stage": 3,
        "code": "Q_EDU_03",
        "text": "출신 학교 등급",
        "type": "single_choice",
        "order": 16,
        "metric_code": "education",
        "options": [
            {"code": "O_EDU_03_A", "text": "서울대학교(S군)", "score": 15},
            {"code": "O_EDU_03_B", "text": "해외 최상위 대학", "score": 14},
            {"code": "O_EDU_03_C", "text": "연세대/고려대(A군)", "score": 13},
            {"code": "O_EDU_03_D", "text": "서강대/성균관대/한양대(B군)", "score": 11},
            {"code": "O_EDU_03_E", "text": "해외 상위권 대학", "score": 10},
            {"code": "O_EDU_03_F", "text": "중앙대/경희대/외대/시립대/거점 국립대(C군)", "score": 9},
            {"code": "O_EDU_03_G", "text": "건국대/동국대/홍익대 등 서울권(D군)", "score": 7},
            {"code": "O_EDU_03_H", "text": "지방 국립대", "score": 6},
            {"code": "O_EDU_03_I", "text": "지방 사립대", "score": 5},
            {"code": "O_EDU_03_J", "text": "해외 일반 대학", "score": 4},
            {"code": "O_EDU_03_K", "text": "전문대(3년제)", "score": 3},
            {"code": "O_EDU_03_L", "text": "전문대(2년제)", "score": 2.5},
            {"code": "O_EDU_03_M", "text": "특목고/자사고", "score": 2},
            {"code": "O_EDU_03_N", "text": "일반고", "score": 1.5},
            {"code": "O_EDU_03_O", "text": "검정고시", "score": 1},
            {"code": "O_EDU_03_P", "text": "기타", "score": 4},
        ],
    },
    {
        "stage": 3,
        "code": "Q_EDU_04",
        "text": "전공 계열",
        "type": "single_choice",
        "order": 17,
        "metric_code": None,
        "options": [
            {"code": "O_EDU_04_A", "text": "의학 계열"},
            {"code": "O_EDU_04_B", "text": "법학 계열"},
            {"code": "O_EDU_04_C", "text": "공학 계열"},
            {"code": "O_EDU_04_D", "text": "자연과학"},
            {"code": "O_EDU_04_E", "text": "경영/경제"},
            {"code": "O_EDU_04_F", "text": "사회과학"},
            {"code": "O_EDU_04_G", "text": "인문"},
            {"code": "O_EDU_04_H", "text": "예체능"},
            {"code": "O_EDU_04_I", "text": "기타"},
        ],
    },
    {
        "stage": 3,
        "code": "Q_EDU_05",
        "text": "졸업 상태",
        "type": "single_choice",
        "order": 18,
        "metric_code": None,
        "options": [
            {"code": "O_EDU_05_A", "text": "졸업"},
            {"code": "O_EDU_05_B", "text": "재학/수료"},
            {"code": "O_EDU_05_C", "text": "중퇴"},
            {"code": "O_EDU_05_D", "text": "기타"},
        ],
    },
    # ── Stage 4: 직업 ─────────────────────────────────────────────────────────
    {
        "stage": 4,
        "code": "Q_JOB_01",
        "text": "직군",
        "type": "single_choice",
        "order": 19,
        "metric_code": None,
        "options": [
            {"code": "O_JOB_01_A", "text": "의료직"},
            {"code": "O_JOB_01_B", "text": "법조직"},
            {"code": "O_JOB_01_C", "text": "금융직"},
            {"code": "O_JOB_01_D", "text": "대기업"},
            {"code": "O_JOB_01_E", "text": "공기업"},
            {"code": "O_JOB_01_F", "text": "공무원"},
            {"code": "O_JOB_01_G", "text": "IT/테크"},
            {"code": "O_JOB_01_H", "text": "교수/연구직"},
            {"code": "O_JOB_01_I", "text": "사업가/자영업"},
            {"code": "O_JOB_01_J", "text": "예술/엔터테인먼트"},
            {"code": "O_JOB_01_K", "text": "프리랜서"},
            {"code": "O_JOB_01_L", "text": "서비스직"},
            {"code": "O_JOB_01_M", "text": "생산/기술직"},
            {"code": "O_JOB_01_N", "text": "기타"},
        ],
    },
    {
        "stage": 4,
        "code": "Q_JOB_02",
        "text": "직업 등급",
        "type": "single_choice",
        "order": 20,
        "metric_code": "job",
        "options": [
            {
                "code": "O_JOB_02_A",
                "text": "S 티어 (의사 / 판사·검사 / 대형 로펌 변호사 / 투자은행 / 성공한 기업 대표)",
                "score": 15,
            },
            {
                "code": "O_JOB_02_B",
                "text": "A 티어 (변호사 / 치·한의사 / 약사 / 대기업 / 금융권 / 교수 / 고연봉 IT)",
                "score": 12,
            },
            {
                "code": "O_JOB_02_C",
                "text": "B 티어 (공기업 / 연구원 / 중견기업 / 개발자 / 교사)",
                "score": 9,
            },
            {
                "code": "O_JOB_02_D",
                "text": "C 티어 (일반 회사원 / 중소기업 / 공무원 / 일반 프리랜서)",
                "score": 6,
            },
            {
                "code": "O_JOB_02_E",
                "text": "D 티어 (서비스직 / 생산직)",
                "score": 3,
            },
            {
                "code": "O_JOB_02_F",
                "text": "E 티어 (무직)",
                "score": 0,
            },
            {
                "code": "O_JOB_02_G",
                "text": "기타",
                "score": 5,
            },
        ],
    },
    # ── Stage 5: 경제력 ───────────────────────────────────────────────────────
    {
        "stage": 5,
        "code": "Q_INC_01",
        "text": "연소득",
        "type": "single_choice",
        "order": 21,
        "metric_code": "income",
        "options": [
            {"code": "O_INC_01_A", "text": "2천만원 미만", "score": 1},
            {"code": "O_INC_01_B", "text": "2천~4천만원", "score": 3},
            {"code": "O_INC_01_C", "text": "4천~6천만원", "score": 5},
            {"code": "O_INC_01_D", "text": "6천~8천만원", "score": 7},
            {"code": "O_INC_01_E", "text": "8천만원~1억", "score": 9},
            {"code": "O_INC_01_F", "text": "1억~1.5억", "score": 11},
            {"code": "O_INC_01_G", "text": "1.5억~2억", "score": 12},
            {"code": "O_INC_01_H", "text": "2억~3억", "score": 13},
            {"code": "O_INC_01_I", "text": "3억 이상", "score": 15},
            {"code": "O_INC_01_J", "text": "기타", "score": 3},
        ],
    },
    {
        "stage": 5,
        "code": "Q_ASSET_01",
        "text": "개인 자산",
        "type": "single_choice",
        "order": 22,
        "metric_code": "asset",
        "options": [
            {"code": "O_ASSET_01_A", "text": "1억 미만", "score": 2},
            {"code": "O_ASSET_01_B", "text": "1억~3억", "score": 5},
            {"code": "O_ASSET_01_C", "text": "3억~5억", "score": 7},
            {"code": "O_ASSET_01_D", "text": "5억~10억", "score": 9},
            {"code": "O_ASSET_01_E", "text": "10억~20억", "score": 11},
            {"code": "O_ASSET_01_F", "text": "20억~50억", "score": 13},
            {"code": "O_ASSET_01_G", "text": "50억 이상", "score": 15},
            {"code": "O_ASSET_01_H", "text": "기타", "score": 4},
        ],
    },
    # ── Stage 6: 가족 배경 ────────────────────────────────────────────────────
    {
        "stage": 6,
        "code": "Q_FAM_01",
        "text": "아버지 직업",
        "type": "single_choice",
        "order": 23,
        "metric_code": None,
        "options": [
            {"code": "O_FAM_01_A", "text": "기업 대표"},
            {"code": "O_FAM_01_B", "text": "임원"},
            {"code": "O_FAM_01_C", "text": "의사"},
            {"code": "O_FAM_01_D", "text": "변호사"},
            {"code": "O_FAM_01_E", "text": "판사/검사"},
            {"code": "O_FAM_01_F", "text": "교수"},
            {"code": "O_FAM_01_G", "text": "금융권"},
            {"code": "O_FAM_01_H", "text": "공기업"},
            {"code": "O_FAM_01_I", "text": "공무원"},
            {"code": "O_FAM_01_J", "text": "일반 회사원"},
            {"code": "O_FAM_01_K", "text": "자영업"},
            {"code": "O_FAM_01_L", "text": "은퇴"},
            {"code": "O_FAM_01_M", "text": "기타"},
        ],
    },
    {
        "stage": 6,
        "code": "Q_FAM_02",
        "text": "어머니 직업",
        "type": "single_choice",
        "order": 24,
        "metric_code": None,
        "options": [
            {"code": "O_FAM_02_A", "text": "기업 대표"},
            {"code": "O_FAM_02_B", "text": "임원"},
            {"code": "O_FAM_02_C", "text": "의사"},
            {"code": "O_FAM_02_D", "text": "변호사"},
            {"code": "O_FAM_02_E", "text": "교수"},
            {"code": "O_FAM_02_F", "text": "금융권"},
            {"code": "O_FAM_02_G", "text": "공기업"},
            {"code": "O_FAM_02_H", "text": "공무원"},
            {"code": "O_FAM_02_I", "text": "일반 회사원"},
            {"code": "O_FAM_02_J", "text": "전업주부"},
            {"code": "O_FAM_02_K", "text": "자영업"},
            {"code": "O_FAM_02_L", "text": "기타"},
        ],
    },
    {
        "stage": 6,
        "code": "Q_FAM_03",
        "text": "부모님 총 자산",
        "type": "single_choice",
        "order": 25,
        "metric_code": "family",
        "options": [
            {"code": "O_FAM_03_A", "text": "5억 미만", "score": 4},
            {"code": "O_FAM_03_B", "text": "5억~10억", "score": 7},
            {"code": "O_FAM_03_C", "text": "10억~20억", "score": 9},
            {"code": "O_FAM_03_D", "text": "20억~50억", "score": 11},
            {"code": "O_FAM_03_E", "text": "50억~100억", "score": 13},
            {"code": "O_FAM_03_F", "text": "100억 이상", "score": 15},
            {"code": "O_FAM_03_G", "text": "기타", "score": 4},
        ],
    },
    # ── Stage 7: 성격 평가 ────────────────────────────────────────────────────
    {
        "stage": 7,
        "code": "Q_PER_01",
        "text": "감정 기복이 적은 편입니다.",
        "type": "single_choice",
        "order": 26,
        "metric_code": "personality",
        "options": [
            {"code": "O_PER_01_A", "text": "매우 그렇다", "score": 2},
            {"code": "O_PER_01_B", "text": "그렇다", "score": 1.5},
            {"code": "O_PER_01_C", "text": "보통", "score": 1},
            {"code": "O_PER_01_D", "text": "아니다", "score": 0.5},
            {"code": "O_PER_01_E", "text": "전혀 아니다", "score": 0},
        ],
    },
    {
        "stage": 7,
        "code": "Q_PER_02",
        "text": "책임감이 강한 편입니다.",
        "type": "single_choice",
        "order": 27,
        "metric_code": "personality",
        "options": [
            {"code": "O_PER_02_A", "text": "매우 그렇다", "score": 2},
            {"code": "O_PER_02_B", "text": "그렇다", "score": 1.5},
            {"code": "O_PER_02_C", "text": "보통", "score": 1},
            {"code": "O_PER_02_D", "text": "아니다", "score": 0.5},
            {"code": "O_PER_02_E", "text": "전혀 아니다", "score": 0},
        ],
    },
    {
        "stage": 7,
        "code": "Q_PER_03",
        "text": "상대방을 배려하는 편입니다.",
        "type": "single_choice",
        "order": 28,
        "metric_code": "personality",
        "options": [
            {"code": "O_PER_03_A", "text": "매우 그렇다", "score": 2},
            {"code": "O_PER_03_B", "text": "그렇다", "score": 1.5},
            {"code": "O_PER_03_C", "text": "보통", "score": 1},
            {"code": "O_PER_03_D", "text": "아니다", "score": 0.5},
            {"code": "O_PER_03_E", "text": "전혀 아니다", "score": 0},
        ],
    },
    {
        "stage": 7,
        "code": "Q_PER_04",
        "text": "약속을 잘 지키는 편입니다.",
        "type": "single_choice",
        "order": 29,
        "metric_code": "personality",
        "options": [
            {"code": "O_PER_04_A", "text": "매우 그렇다", "score": 2},
            {"code": "O_PER_04_B", "text": "그렇다", "score": 1.5},
            {"code": "O_PER_04_C", "text": "보통", "score": 1},
            {"code": "O_PER_04_D", "text": "아니다", "score": 0.5},
            {"code": "O_PER_04_E", "text": "전혀 아니다", "score": 0},
        ],
    },
    {
        "stage": 7,
        "code": "Q_PER_05",
        "text": "갈등이 생기면 대화로 해결하려 합니다.",
        "type": "single_choice",
        "order": 30,
        "metric_code": "personality",
        "options": [
            {"code": "O_PER_05_A", "text": "매우 그렇다", "score": 2},
            {"code": "O_PER_05_B", "text": "그렇다", "score": 1.5},
            {"code": "O_PER_05_C", "text": "보통", "score": 1},
            {"code": "O_PER_05_D", "text": "아니다", "score": 0.5},
            {"code": "O_PER_05_E", "text": "전혀 아니다", "score": 0},
        ],
    },
    # ── Stage 8: 라이프스타일 ─────────────────────────────────────────────────
    {
        "stage": 8,
        "code": "Q_LST_01",
        "text": "운동 빈도",
        "type": "single_choice",
        "order": 31,
        "metric_code": "lifestyle",
        "options": [
            {"code": "O_LST_01_A", "text": "매일", "score": 2},
            {"code": "O_LST_01_B", "text": "주 3~4회", "score": 1.5},
            {"code": "O_LST_01_C", "text": "주 1~2회", "score": 1},
            {"code": "O_LST_01_D", "text": "가끔", "score": 0.5},
            {"code": "O_LST_01_E", "text": "하지 않음", "score": 0},
        ],
    },
    {
        "stage": 8,
        "code": "Q_LST_02",
        "text": "독서 빈도",
        "type": "single_choice",
        "order": 32,
        "metric_code": "lifestyle",
        "options": [
            {"code": "O_LST_02_A", "text": "월 4권 이상", "score": 1},
            {"code": "O_LST_02_B", "text": "월 1~3권", "score": 0.7},
            {"code": "O_LST_02_C", "text": "가끔", "score": 0.3},
            {"code": "O_LST_02_D", "text": "읽지 않음", "score": 0},
        ],
    },
    {
        "stage": 8,
        "code": "Q_LST_03",
        "text": "소비 성향",
        "type": "single_choice",
        "order": 33,
        "metric_code": "lifestyle",
        "options": [
            {"code": "O_LST_03_A", "text": "철저히 계획적", "score": 1},
            {"code": "O_LST_03_B", "text": "대체로 계획적", "score": 0.8},
            {"code": "O_LST_03_C", "text": "보통", "score": 0.5},
            {"code": "O_LST_03_D", "text": "약간 충동적", "score": 0.2},
            {"code": "O_LST_03_E", "text": "충동적", "score": 0},
        ],
    },
    {
        "stage": 8,
        "code": "Q_LST_04",
        "text": "저축 성향",
        "type": "single_choice",
        "order": 34,
        "metric_code": "lifestyle",
        "options": [
            {"code": "O_LST_04_A", "text": "소득의 50% 이상 저축", "score": 1},
            {"code": "O_LST_04_B", "text": "30~50% 저축", "score": 0.8},
            {"code": "O_LST_04_C", "text": "10~30% 저축", "score": 0.5},
            {"code": "O_LST_04_D", "text": "10% 미만 저축", "score": 0.2},
            {"code": "O_LST_04_E", "text": "저축 안 함", "score": 0},
        ],
    },
]


async def seed():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    async with engine.begin() as conn:
        await conn.execute(
            text(
                "TRUNCATE TABLE scoring_rules, question_options, questions, "
                "questionnaires, metrics RESTART IDENTITY CASCADE"
            )
        )

    async with AsyncSessionLocal() as db:
        # ── Insert metrics ────────────────────────────────────────────────────
        metric_map: dict[str, Metric] = {}
        for m in METRICS:
            metric = Metric(
                code=m["code"],
                name=m["name"],
                description=m["description"],
                is_active=True,
            )
            db.add(metric)
            await db.flush()
            metric_map[m["code"]] = metric

        # ── Insert questionnaire ──────────────────────────────────────────────
        questionnaire = Questionnaire(
            version_no=1,
            name="결혼 적합도 평가 v1",
            target_gender=None,
            is_published=True,
        )
        db.add(questionnaire)
        await db.flush()

        # ── Insert questions, options, scoring rules ───────────────────────────
        total_options = 0
        total_rules = 0

        for q_data in QUESTIONS:
            metric_code = q_data.get("metric_code")
            metric = metric_map[metric_code] if metric_code else None

            question = Question(
                questionnaire_id=questionnaire.questionnaire_id,
                metric_id=metric.metric_id if metric else None,
                code=q_data["code"],
                question_text=q_data["text"],
                question_type=q_data["type"],
                display_order=q_data["order"],
                is_required=True,
            )
            db.add(question)
            await db.flush()

            for idx, opt_data in enumerate(q_data["options"]):
                option = QuestionOption(
                    question_id=question.question_id,
                    option_code=opt_data["code"],
                    option_text=opt_data["text"],
                    display_order=idx + 1,
                )
                db.add(option)
                await db.flush()
                total_options += 1

                # Only create a ScoringRule when there is a score AND a metric
                if "score" in opt_data and metric is not None:
                    rule = ScoringRule(
                        questionnaire_id=questionnaire.questionnaire_id,
                        metric_id=metric.metric_id,
                        question_id=question.question_id,
                        option_id=option.option_id,
                        score=float(opt_data["score"]),
                        weight=1.0,
                    )
                    db.add(rule)
                    total_rules += 1

        await db.commit()

    print(
        f"Seeded successfully:\n"
        f"  Metrics      : {len(METRICS)}\n"
        f"  Questionnaire: 1 (version_no=1)\n"
        f"  Questions    : {len(QUESTIONS)}\n"
        f"  Options      : {total_options}\n"
        f"  Scoring rules: {total_rules}"
    )


if __name__ == "__main__":
    asyncio.run(seed())
