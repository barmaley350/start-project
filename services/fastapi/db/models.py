# models.py
import uuid
from enum import StrEnum

from sqlalchemy import (
    Column,
    String,
    ForeignKey,
    TIMESTAMP,
    SmallInteger,
    UniqueConstraint,
    Integer,
    Float,
    Boolean,
    Enum,
)
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship, declarative_base
from sqlalchemy.sql import func

Base = declarative_base()

from typing import TYPE_CHECKING

if TYPE_CHECKING:
    pass
else:

    def dataclass_sql(cls):
        return cls


Base = declarative_base()


# =============== Association Tables ===============
class UserGoal(Base):
    """Association table for user-goal many-to-many relationship"""

    __tablename__ = "user_goals"

    user_id = Column(
        UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), primary_key=True
    )
    goal_id = Column(
        UUID(as_uuid=True), ForeignKey("goals.id", ondelete="CASCADE"), primary_key=True
    )


class UserSkill(Base):
    """Association table for user-skill many-to-many relationship (general skills)"""

    __tablename__ = "user_skills"

    user_id = Column(
        UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), primary_key=True
    )
    skill_id = Column(
        UUID(as_uuid=True),
        ForeignKey("skills.id", ondelete="CASCADE"),
        primary_key=True,
    )


class UserMentorSkill(Base):
    """Association table for user-mentor_skill many-to-many relationship"""

    __tablename__ = "user_mentor_skills"

    user_id = Column(
        UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), primary_key=True
    )
    skill_id = Column(
        UUID(as_uuid=True),
        ForeignKey("skills.id", ondelete="CASCADE"),
        primary_key=True,
    )


class UserMenteeSkill(Base):
    """Association table for user-mentee_skill many-to-many relationship"""

    __tablename__ = "user_mentee_skills"

    user_id = Column(
        UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), primary_key=True
    )
    skill_id = Column(
        UUID(as_uuid=True),
        ForeignKey("skills.id", ondelete="CASCADE"),
        primary_key=True,
    )


class UserQuant(Base):
    """User availability in time quants"""

    __tablename__ = "user_quants"

    user_id = Column(
        UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), primary_key=True
    )
    quant_id = Column(
        SmallInteger, ForeignKey("time_quants.id", ondelete="CASCADE"), primary_key=True
    )


# =============== Main Models ===============
class City(Base):
    """City model"""

    __tablename__ = "cities"

    id = Column(Integer, primary_key=True)
    country = Column(String(128))
    city = Column(String(256), nullable=False)
    timezone = Column(String(256), nullable=False, server_default="UTC")

    # Relationships
    users = relationship("User", back_populates="city", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<City(id={self.id}, city='{self.city}', country='{self.country}')>"


class User(Base):
    """User model"""

    __tablename__ = "users"

    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
        server_default=func.gen_random_uuid(),
    )
    username = Column(String(64))
    first_name = Column(String(64))
    last_name = Column(String(64))
    bio = Column(String(4096))
    rate = Column(SmallInteger, nullable=True, server_default="0")
    city_id = Column(Integer, ForeignKey("cities.id", ondelete="CASCADE"))
    created_at = Column(TIMESTAMP, nullable=False, server_default=func.now())
    updated_at = Column(
        TIMESTAMP, nullable=False, server_default=func.now(), onupdate=func.now()
    )
    is_active = Column(Boolean, nullable=False, server_default="True")

    # Relationships
    city = relationship("City", back_populates="users")

    photos = relationship(
        "UserPhoto", back_populates="user", cascade="all, delete-orphan"
    )
    telegram = relationship(
        "UserTelegram",
        back_populates="user",
        uselist=False,
        cascade="all, delete-orphan",
    )
    contacts = relationship(
        "UserContact", back_populates="user", cascade="all, delete-orphan"
    )

    goals = relationship("Goal", secondary=UserGoal.__table__, back_populates="users")
    skills = relationship(
        "Skill", secondary=UserSkill.__table__, back_populates="users"
    )
    mentor_skills = relationship(
        "Skill", secondary=UserMentorSkill.__table__, back_populates="mentor_users"
    )
    mentee_skills = relationship(
        "Skill", secondary=UserMenteeSkill.__table__, back_populates="mentee_users"
    )

    # Matches
    match_requests_sent = relationship(
        "MatchRequest",
        foreign_keys="MatchRequest.user_id",
        back_populates="user",
        cascade="all, delete-orphan",
    )
    match_requests_received = relationship(
        "MatchRequest",
        foreign_keys="MatchRequest.target_user_id",
        back_populates="target_user",
        cascade="all, delete-orphan",
    )
    possible_matches_sent = relationship(
        "PossibleMatch",
        foreign_keys="PossibleMatch.user_id",
        back_populates="user",
        cascade="all, delete-orphan",
    )
    matches_initiated = relationship(
        "Match",
        foreign_keys="Match.user_id",
        back_populates="initiator",
        cascade="all, delete-orphan",
    )
    matches_received = relationship(
        "Match",
        foreign_keys="Match.target_user_id",
        back_populates="target_user",
        cascade="all, delete-orphan",
    )

    # Availability intervals
    quants = relationship(
        "TimeQuant", secondary=UserQuant.__table__, back_populates="users"
    )

    def __repr__(self):
        return f"<User(id={self.id}, username='{self.username}')>"

    @property
    def full_name(self):
        """Get user's full name"""
        if self.first_name and self.last_name:
            return f"{self.first_name} {self.last_name}"
        return self.first_name or self.last_name or self.username


class PossibleMatchStatus(StrEnum):
    CURRENT = "CURRENT"
    LAST = "LAST"
    NEXT = "NEXT"


class PossibleMatch(Base):
    """Possible matches"""

    __tablename__ = "possible_matches"
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
        server_default=func.gen_random_uuid(),
    )
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    target_user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    score = Column(Float, nullable=False)
    created_at = Column(TIMESTAMP, nullable=False, server_default=func.now())
    status = Column(
        Enum(PossibleMatchStatus),
        nullable=False,
        server_default=PossibleMatchStatus.CURRENT,
    )

    user = relationship("User", foreign_keys=[user_id])
    target_user = relationship("User", foreign_keys=[target_user_id])


class MatchRequestStatus(StrEnum):
    PENDING = "PENDING"
    APPROVED = "APPROVED"
    REJECTED = "REJECTED"


class MatchRequest(Base):
    """User contact requests"""

    __tablename__ = "match_requests"
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
        server_default=func.gen_random_uuid(),
    )
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    target_user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    created_at = Column(TIMESTAMP, nullable=False, server_default=func.now())

    user = relationship("User", foreign_keys=[user_id])
    target_user = relationship("User", foreign_keys=[target_user_id])
    status = Column(
        Enum(MatchRequestStatus), server_default=MatchRequestStatus.PENDING
    )  # PENDING/APPROVED/REJECTED


class UserPhoto(Base):
    """User photos (telegram URL or S3 key)"""

    __tablename__ = "user_photos"
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
        server_default=func.gen_random_uuid(),
    )

    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"))
    photo_type = Column(String(20))  # icon/preview/big_picture
    photo_url = Column(String(256))  # photo url from telegram
    photo_s3_key = Column(String(128))  # photo s3 in s3 bucket

    # Relationships
    user = relationship("User", back_populates="photos")

    __table_args__ = (
        UniqueConstraint("user_id", "photo_type", name="uq_user_photo_type"),
    )

    def __repr__(self):
        return f"<UserPhoto(user_id={self.user_id}, type='{self.photo_type}')>"


class UserTelegram(Base):
    """User Telegram information"""

    __tablename__ = "user_telegram"

    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"))
    telegram_id = Column(Integer, primary_key=True)
    telegram_username = Column(String(64), nullable=False)

    # Relationships
    user = relationship("User", back_populates="telegram")

    def __repr__(self):
        return f"<UserTelegram(user_id={self.user_id}, username='{self.telegram_username}')>"


class UserContact(Base):
    """User contact information"""

    __tablename__ = "user_contacts"

    user_id = Column(
        UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), primary_key=True
    )
    value = Column(String(100), nullable=False)
    contact_type = Column(String(10), primary_key=True)

    # Relationships
    user = relationship("User", back_populates="contacts")

    __table_args__ = (UniqueConstraint("value", name="uq_contact_value"),)

    def __repr__(self):
        return f"<UserContact(user_id={self.user_id}, type='{self.contact_type}', value='{self.value}')>"


class Category(Base):
    """Categories for skills and interests"""

    __tablename__ = "categories"

    id = Column(
        Integer,
        primary_key=True,
    )
    name = Column(String(100), unique=True, nullable=False)
    weight = Column(Float, nullable=False, default=0)

    # Relationships
    skills = relationship(
        "Skill", back_populates="category", cascade="all, delete-orphan"
    )

    def __repr__(self):
        return f"<Category(id={self.id}, name='{self.name}')>"


class Goal(Base):
    """User goals"""

    __tablename__ = "goals"

    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
        server_default=func.gen_random_uuid(),
    )
    name = Column(String(100), unique=True, nullable=False)

    # Relationships
    users = relationship("User", secondary=UserGoal.__table__, back_populates="goals")

    def __repr__(self):
        return f"<Goal(id={self.id}, name='{self.name}')>"


class Skill(Base):
    """Skills"""

    __tablename__ = "skills"

    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
        server_default=func.gen_random_uuid(),
    )
    name = Column(String(100), unique=True, nullable=False)
    weight = Column(Float, nullable=True, default=1)
    category_id = Column(Integer, ForeignKey("categories.id", ondelete="CASCADE"))

    # Relationships
    category = relationship("Category", back_populates="skills")
    users = relationship("User", secondary=UserSkill.__table__, back_populates="skills")
    mentor_users = relationship(
        "User", secondary=UserMentorSkill.__table__, back_populates="mentor_skills"
    )
    mentee_users = relationship(
        "User", secondary=UserMenteeSkill.__table__, back_populates="mentee_skills"
    )

    def __repr__(self):
        return f"<Skill(id={self.id}, name='{self.name}', weight={self.weight})>"


class MatchStatus(StrEnum):
    FOLLOWING = "FOLLOWING"  # Pre-screening to the next after the current meeting
    UNCOMPLETED = "UNCOMPLETED"
    CANCELED_BY_INITIATOR = "CANCELED_BY_INITIATOR"
    CANCELED_BY_TARGET = "CANCELED_BY_TARGET"
    COMPLETED = "COMPLETED"
    SKIPPED = "SKIPPED"


class Match(Base):
    """Matches between users"""

    __tablename__ = "matches"

    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
        server_default=func.gen_random_uuid(),
    )
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"))
    target_user_id = Column(
        UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE")
    )
    date_at = Column(TIMESTAMP, nullable=False, server_default=func.now())
    status = Column(
        Enum(MatchStatus), server_default=MatchStatus.UNCOMPLETED
    )  # UNCOMPLETED / CANCELED_BY_INITIATOR / CANCELED_BY_TARGET / COMPLETED / SKIPPED
    rate = Column(SmallInteger, nullable=True, server_default="0")  # -100 0-100

    # Rating given by initiator to target user
    # Unique constraint
    __table_args__ = (
        UniqueConstraint(
            "user_id", "target_user_id", "date_at", name="unique_user_target_date"
        ),
    )

    # Relationships
    initiator = relationship(
        "User", foreign_keys=[user_id], back_populates="matches_initiated"
    )
    target_user = relationship(
        "User", foreign_keys=[target_user_id], back_populates="matches_received"
    )

    def __repr__(self):
        return f"<Match(id={self.id}, user_id={self.user_id}, target_user_id={self.target_user_id}, status='{self.status}')>"


class TimeQuant(Base):
    """Time quantums for scheduling (7 days * 24 hours = 168 slots)"""

    __tablename__ = "time_quants"

    id = Column(SmallInteger, primary_key=True)
    hour = Column(SmallInteger, nullable=False)  # 0-23
    day = Column(SmallInteger, nullable=False)  # 0-6

    # Relationships
    users = relationship("User", secondary=UserQuant.__table__, back_populates="quants")

    def __repr__(self):
        return f"<TimeQuant(id={self.id}, day={self.day}, hour={self.hour})>"

    @property
    def time_slot(self):
        """Get human-readable time slot"""
        hour_map = {
            0: "00:00-01:00",
            1: "01:00-02:00",
            2: "02:00-03:00",
            3: "03:00-04:00",
            4: "04:00-05:00",
            5: "05:00-06:00",
            6: "06:00-07:00",
            7: "07:00-08:00",
            8: "08:00-09:00",
            9: "09:00-10:00",
            10: "10:00-11:00",
            11: "11:00-12:00",
            12: "12:00-13:00",
            13: "13:00-14:00",
            14: "14:00-15:00",
            15: "15:00-16:00",
            16: "16:00-17:00",
            17: "17:00-18:00",
            18: "18:00-19:00",
            19: "19:00-20:00",
            20: "20:00-21:00",
            21: "21:00-22:00",
            22: "22:00-23:00",
            23: "23:00-00:00",
        }
        day_map = {
            0: "Monday",
            1: "Tuesday",
            2: "Wednesday",
            3: "Thursday",
            4: "Friday",
            5: "Saturday",
            6: "Sunday",
        }
        return (
            f"{day_map.get(self.day, 'Unknown')} {hour_map.get(self.hour, 'Unknown')}"
        )
