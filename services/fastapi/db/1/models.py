from typing import Optional
import datetime

from sqlalchemy import BigInteger, Boolean, CheckConstraint, DateTime, ForeignKeyConstraint, Identity, Index, Integer, PrimaryKeyConstraint, SmallInteger, String, Text, UniqueConstraint
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column, relationship

class Base(DeclarativeBase):
    pass


class AuthCheckAdminerpermission(Base):
    __tablename__ = 'auth_check_adminerpermission'
    __table_args__ = (
        PrimaryKeyConstraint('id', name='auth_check_adminerpermission_pkey'),
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(start=1, increment=1, minvalue=1, maxvalue=9223372036854775807, cycle=False, cache=1), primary_key=True)


class AuthCheckJupyterpermission(Base):
    __tablename__ = 'auth_check_jupyterpermission'
    __table_args__ = (
        PrimaryKeyConstraint('id', name='auth_check_jupyterpermission_pkey'),
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(start=1, increment=1, minvalue=1, maxvalue=9223372036854775807, cycle=False, cache=1), primary_key=True)


class AuthCheckSphinxdocspermission(Base):
    __tablename__ = 'auth_check_sphinxdocspermission'
    __table_args__ = (
        PrimaryKeyConstraint('id', name='auth_check_sphinxdocspermission_pkey'),
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(start=1, increment=1, minvalue=1, maxvalue=9223372036854775807, cycle=False, cache=1), primary_key=True)


class AuthGroup(Base):
    __tablename__ = 'auth_group'
    __table_args__ = (
        PrimaryKeyConstraint('id', name='auth_group_pkey'),
        UniqueConstraint('name', name='auth_group_name_key'),
        Index('auth_group_name_a6ea08ec_like', 'name')
    )

    id: Mapped[int] = mapped_column(Integer, Identity(start=1, increment=1, minvalue=1, maxvalue=2147483647, cycle=False, cache=1), primary_key=True)
    name: Mapped[str] = mapped_column(String(150), nullable=False)

    auth_user_groups: Mapped[list['AuthUserGroups']] = relationship('AuthUserGroups', back_populates='group')
    auth_group_permissions: Mapped[list['AuthGroupPermissions']] = relationship('AuthGroupPermissions', back_populates='group')


class AuthUser(Base):
    __tablename__ = 'auth_user'
    __table_args__ = (
        PrimaryKeyConstraint('id', name='auth_user_pkey'),
        UniqueConstraint('username', name='auth_user_username_key'),
        Index('auth_user_username_6821ab7c_like', 'username')
    )

    id: Mapped[int] = mapped_column(Integer, Identity(start=1, increment=1, minvalue=1, maxvalue=2147483647, cycle=False, cache=1), primary_key=True)
    password: Mapped[str] = mapped_column(String(128), nullable=False)
    is_superuser: Mapped[bool] = mapped_column(Boolean, nullable=False)
    username: Mapped[str] = mapped_column(String(150), nullable=False)
    first_name: Mapped[str] = mapped_column(String(150), nullable=False)
    last_name: Mapped[str] = mapped_column(String(150), nullable=False)
    email: Mapped[str] = mapped_column(String(254), nullable=False)
    is_staff: Mapped[bool] = mapped_column(Boolean, nullable=False)
    is_active: Mapped[bool] = mapped_column(Boolean, nullable=False)
    date_joined: Mapped[datetime.datetime] = mapped_column(DateTime(True), nullable=False)
    last_login: Mapped[Optional[datetime.datetime]] = mapped_column(DateTime(True))

    auth_user_groups: Mapped[list['AuthUserGroups']] = relationship('AuthUserGroups', back_populates='user')
    django_admin_log: Mapped[list['DjangoAdminLog']] = relationship('DjangoAdminLog', back_populates='user')
    testapp_project: Mapped[list['TestappProject']] = relationship('TestappProject', back_populates='owner')
    auth_user_user_permissions: Mapped[list['AuthUserUserPermissions']] = relationship('AuthUserUserPermissions', back_populates='user')
    testapp_comment: Mapped[list['TestappComment']] = relationship('TestappComment', back_populates='owner')


class DjangoContentType(Base):
    __tablename__ = 'django_content_type'
    __table_args__ = (
        PrimaryKeyConstraint('id', name='django_content_type_pkey'),
        UniqueConstraint('app_label', 'model', name='django_content_type_app_label_model_76bd3d3b_uniq')
    )

    id: Mapped[int] = mapped_column(Integer, Identity(start=1, increment=1, minvalue=1, maxvalue=2147483647, cycle=False, cache=1), primary_key=True)
    app_label: Mapped[str] = mapped_column(String(100), nullable=False)
    model: Mapped[str] = mapped_column(String(100), nullable=False)

    auth_permission: Mapped[list['AuthPermission']] = relationship('AuthPermission', back_populates='content_type')
    django_admin_log: Mapped[list['DjangoAdminLog']] = relationship('DjangoAdminLog', back_populates='content_type')


class DjangoMigrations(Base):
    __tablename__ = 'django_migrations'
    __table_args__ = (
        PrimaryKeyConstraint('id', name='django_migrations_pkey'),
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(start=1, increment=1, minvalue=1, maxvalue=9223372036854775807, cycle=False, cache=1), primary_key=True)
    app: Mapped[str] = mapped_column(String(255), nullable=False)
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    applied: Mapped[datetime.datetime] = mapped_column(DateTime(True), nullable=False)


class DjangoSession(Base):
    __tablename__ = 'django_session'
    __table_args__ = (
        PrimaryKeyConstraint('session_key', name='django_session_pkey'),
        Index('django_session_expire_date_a5c62663', 'expire_date'),
        Index('django_session_session_key_c0390e0f_like', 'session_key')
    )

    session_key: Mapped[str] = mapped_column(String(40), primary_key=True)
    session_data: Mapped[str] = mapped_column(Text, nullable=False)
    expire_date: Mapped[datetime.datetime] = mapped_column(DateTime(True), nullable=False)


class TestappTag(Base):
    __tablename__ = 'testapp_tag'
    __table_args__ = (
        PrimaryKeyConstraint('id', name='testapp_tag_pkey'),
        UniqueConstraint('name', name='testapp_tag_name_key'),
        UniqueConstraint('slug', name='testapp_tag_slug_key'),
        Index('testapp_tag_name_94769abb_like', 'name'),
        Index('testapp_tag_slug_c93666de_like', 'slug')
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(start=1, increment=1, minvalue=1, maxvalue=9223372036854775807, cycle=False, cache=1), primary_key=True)
    name: Mapped[str] = mapped_column(String(50), nullable=False)
    slug: Mapped[str] = mapped_column(String(50), nullable=False)

    testapp_project_tags: Mapped[list['TestappProjectTags']] = relationship('TestappProjectTags', back_populates='tag')


class AuthPermission(Base):
    __tablename__ = 'auth_permission'
    __table_args__ = (
        ForeignKeyConstraint(['content_type_id'], ['django_content_type.id'], deferrable=True, initially='DEFERRED', name='auth_permission_content_type_id_2f476e4b_fk_django_co'),
        PrimaryKeyConstraint('id', name='auth_permission_pkey'),
        UniqueConstraint('content_type_id', 'codename', name='auth_permission_content_type_id_codename_01ab375a_uniq'),
        Index('auth_permission_content_type_id_2f476e4b', 'content_type_id')
    )

    id: Mapped[int] = mapped_column(Integer, Identity(start=1, increment=1, minvalue=1, maxvalue=2147483647, cycle=False, cache=1), primary_key=True)
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    content_type_id: Mapped[int] = mapped_column(Integer, nullable=False)
    codename: Mapped[str] = mapped_column(String(100), nullable=False)

    content_type: Mapped['DjangoContentType'] = relationship('DjangoContentType', back_populates='auth_permission')
    auth_group_permissions: Mapped[list['AuthGroupPermissions']] = relationship('AuthGroupPermissions', back_populates='permission')
    auth_user_user_permissions: Mapped[list['AuthUserUserPermissions']] = relationship('AuthUserUserPermissions', back_populates='permission')


class AuthUserGroups(Base):
    __tablename__ = 'auth_user_groups'
    __table_args__ = (
        ForeignKeyConstraint(['group_id'], ['auth_group.id'], deferrable=True, initially='DEFERRED', name='auth_user_groups_group_id_97559544_fk_auth_group_id'),
        ForeignKeyConstraint(['user_id'], ['auth_user.id'], deferrable=True, initially='DEFERRED', name='auth_user_groups_user_id_6a12ed8b_fk_auth_user_id'),
        PrimaryKeyConstraint('id', name='auth_user_groups_pkey'),
        UniqueConstraint('user_id', 'group_id', name='auth_user_groups_user_id_group_id_94350c0c_uniq'),
        Index('auth_user_groups_group_id_97559544', 'group_id'),
        Index('auth_user_groups_user_id_6a12ed8b', 'user_id')
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(start=1, increment=1, minvalue=1, maxvalue=9223372036854775807, cycle=False, cache=1), primary_key=True)
    user_id: Mapped[int] = mapped_column(Integer, nullable=False)
    group_id: Mapped[int] = mapped_column(Integer, nullable=False)

    group: Mapped['AuthGroup'] = relationship('AuthGroup', back_populates='auth_user_groups')
    user: Mapped['AuthUser'] = relationship('AuthUser', back_populates='auth_user_groups')


class DjangoAdminLog(Base):
    __tablename__ = 'django_admin_log'
    __table_args__ = (
        CheckConstraint('action_flag >= 0', name='django_admin_log_action_flag_check'),
        ForeignKeyConstraint(['content_type_id'], ['django_content_type.id'], deferrable=True, initially='DEFERRED', name='django_admin_log_content_type_id_c4bce8eb_fk_django_co'),
        ForeignKeyConstraint(['user_id'], ['auth_user.id'], deferrable=True, initially='DEFERRED', name='django_admin_log_user_id_c564eba6_fk_auth_user_id'),
        PrimaryKeyConstraint('id', name='django_admin_log_pkey'),
        Index('django_admin_log_content_type_id_c4bce8eb', 'content_type_id'),
        Index('django_admin_log_user_id_c564eba6', 'user_id')
    )

    id: Mapped[int] = mapped_column(Integer, Identity(start=1, increment=1, minvalue=1, maxvalue=2147483647, cycle=False, cache=1), primary_key=True)
    action_time: Mapped[datetime.datetime] = mapped_column(DateTime(True), nullable=False)
    object_repr: Mapped[str] = mapped_column(String(200), nullable=False)
    action_flag: Mapped[int] = mapped_column(SmallInteger, nullable=False)
    change_message: Mapped[str] = mapped_column(Text, nullable=False)
    user_id: Mapped[int] = mapped_column(Integer, nullable=False)
    object_id: Mapped[Optional[str]] = mapped_column(Text)
    content_type_id: Mapped[Optional[int]] = mapped_column(Integer)

    content_type: Mapped[Optional['DjangoContentType']] = relationship('DjangoContentType', back_populates='django_admin_log')
    user: Mapped['AuthUser'] = relationship('AuthUser', back_populates='django_admin_log')


class TestappProject(Base):
    __tablename__ = 'testapp_project'
    __table_args__ = (
        ForeignKeyConstraint(['owner_id'], ['auth_user.id'], deferrable=True, initially='DEFERRED', name='testapp_project_owner_id_8fc807c2_fk_auth_user_id'),
        PrimaryKeyConstraint('id', name='testapp_project_pkey'),
        Index('testapp_project_owner_id_8fc807c2', 'owner_id')
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(start=1, increment=1, minvalue=1, maxvalue=9223372036854775807, cycle=False, cache=1), primary_key=True)
    title: Mapped[str] = mapped_column(String(250), nullable=False)
    description: Mapped[str] = mapped_column(Text, nullable=False)
    owner_id: Mapped[int] = mapped_column(Integer, nullable=False)
    created_at: Mapped[datetime.datetime] = mapped_column(DateTime(True), nullable=False)
    updated_at: Mapped[datetime.datetime] = mapped_column(DateTime(True), nullable=False)

    owner: Mapped['AuthUser'] = relationship('AuthUser', back_populates='testapp_project')
    testapp_comment: Mapped[list['TestappComment']] = relationship('TestappComment', back_populates='project')
    testapp_project_tags: Mapped[list['TestappProjectTags']] = relationship('TestappProjectTags', back_populates='project')


class AuthGroupPermissions(Base):
    __tablename__ = 'auth_group_permissions'
    __table_args__ = (
        ForeignKeyConstraint(['group_id'], ['auth_group.id'], deferrable=True, initially='DEFERRED', name='auth_group_permissions_group_id_b120cbf9_fk_auth_group_id'),
        ForeignKeyConstraint(['permission_id'], ['auth_permission.id'], deferrable=True, initially='DEFERRED', name='auth_group_permissio_permission_id_84c5c92e_fk_auth_perm'),
        PrimaryKeyConstraint('id', name='auth_group_permissions_pkey'),
        UniqueConstraint('group_id', 'permission_id', name='auth_group_permissions_group_id_permission_id_0cd325b0_uniq'),
        Index('auth_group_permissions_group_id_b120cbf9', 'group_id'),
        Index('auth_group_permissions_permission_id_84c5c92e', 'permission_id')
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(start=1, increment=1, minvalue=1, maxvalue=9223372036854775807, cycle=False, cache=1), primary_key=True)
    group_id: Mapped[int] = mapped_column(Integer, nullable=False)
    permission_id: Mapped[int] = mapped_column(Integer, nullable=False)

    group: Mapped['AuthGroup'] = relationship('AuthGroup', back_populates='auth_group_permissions')
    permission: Mapped['AuthPermission'] = relationship('AuthPermission', back_populates='auth_group_permissions')


class AuthUserUserPermissions(Base):
    __tablename__ = 'auth_user_user_permissions'
    __table_args__ = (
        ForeignKeyConstraint(['permission_id'], ['auth_permission.id'], deferrable=True, initially='DEFERRED', name='auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm'),
        ForeignKeyConstraint(['user_id'], ['auth_user.id'], deferrable=True, initially='DEFERRED', name='auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id'),
        PrimaryKeyConstraint('id', name='auth_user_user_permissions_pkey'),
        UniqueConstraint('user_id', 'permission_id', name='auth_user_user_permissions_user_id_permission_id_14a6b632_uniq'),
        Index('auth_user_user_permissions_permission_id_1fbb5f2c', 'permission_id'),
        Index('auth_user_user_permissions_user_id_a95ead1b', 'user_id')
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(start=1, increment=1, minvalue=1, maxvalue=9223372036854775807, cycle=False, cache=1), primary_key=True)
    user_id: Mapped[int] = mapped_column(Integer, nullable=False)
    permission_id: Mapped[int] = mapped_column(Integer, nullable=False)

    permission: Mapped['AuthPermission'] = relationship('AuthPermission', back_populates='auth_user_user_permissions')
    user: Mapped['AuthUser'] = relationship('AuthUser', back_populates='auth_user_user_permissions')


class TestappComment(Base):
    __tablename__ = 'testapp_comment'
    __table_args__ = (
        ForeignKeyConstraint(['owner_id'], ['auth_user.id'], deferrable=True, initially='DEFERRED', name='testapp_comments_owner_id_d168cad4_fk_auth_user_id'),
        ForeignKeyConstraint(['project_id'], ['testapp_project.id'], deferrable=True, initially='DEFERRED', name='testapp_comment_project_id_651cd9f5_fk_testapp_project_id'),
        PrimaryKeyConstraint('id', name='testapp_comments_pkey'),
        Index('testapp_comments_owner_id_d168cad4', 'owner_id'),
        Index('testapp_comments_project_id_840a640e', 'project_id')
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(start=1, increment=1, minvalue=1, maxvalue=9223372036854775807, cycle=False, cache=1), primary_key=True)
    title: Mapped[str] = mapped_column(String(250), nullable=False)
    description: Mapped[str] = mapped_column(Text, nullable=False)
    owner_id: Mapped[int] = mapped_column(Integer, nullable=False)
    project_id: Mapped[int] = mapped_column(BigInteger, nullable=False)
    created_at: Mapped[datetime.datetime] = mapped_column(DateTime(True), nullable=False)
    updated_at: Mapped[datetime.datetime] = mapped_column(DateTime(True), nullable=False)
    parent_id: Mapped[int] = mapped_column(Integer, nullable=False)

    owner: Mapped['AuthUser'] = relationship('AuthUser', back_populates='testapp_comment')
    project: Mapped['TestappProject'] = relationship('TestappProject', back_populates='testapp_comment')


class TestappProjectTags(Base):
    __tablename__ = 'testapp_project_tags'
    __table_args__ = (
        ForeignKeyConstraint(['project_id'], ['testapp_project.id'], deferrable=True, initially='DEFERRED', name='testapp_project_tags_project_id_2284660d_fk_testapp_project_id'),
        ForeignKeyConstraint(['tag_id'], ['testapp_tag.id'], deferrable=True, initially='DEFERRED', name='testapp_project_tags_tag_id_629c17f8_fk_testapp_tag_id'),
        PrimaryKeyConstraint('id', name='testapp_project_tags_pkey'),
        UniqueConstraint('project_id', 'tag_id', name='testapp_project_tags_project_id_tag_id_d6d041bc_uniq'),
        Index('testapp_project_tags_project_id_2284660d', 'project_id'),
        Index('testapp_project_tags_tag_id_629c17f8', 'tag_id')
    )

    id: Mapped[int] = mapped_column(BigInteger, Identity(start=1, increment=1, minvalue=1, maxvalue=9223372036854775807, cycle=False, cache=1), primary_key=True)
    project_id: Mapped[int] = mapped_column(BigInteger, nullable=False)
    tag_id: Mapped[int] = mapped_column(BigInteger, nullable=False)

    project: Mapped['TestappProject'] = relationship('TestappProject', back_populates='testapp_project_tags')
    tag: Mapped['TestappTag'] = relationship('TestappTag', back_populates='testapp_project_tags')
