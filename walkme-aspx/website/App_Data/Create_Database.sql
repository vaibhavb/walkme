use master
GO
if not exists (select database_id from sys.databases where name='walkme')
	begin
		create database walkme
	end;
GO

-- +------------------------------------------------------------------------+
-- | CLEANUP
-- +------------------------------------------------------------------------+

use walkme

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[wc_audit_log]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[wc_audit_log](
	[log_id] [int] IDENTITY(1,1) NOT NULL,
	[application_name] [nvarchar](50) NOT NULL,
	[server_name] [nvarchar](128) NOT NULL,
	[executing_entity] [nvarchar](128) NOT NULL,
	[event_id] [int] NOT NULL,
	[event_severity] [int] NOT NULL,
	[event_time] [datetime] NOT NULL,
	[event_message] [nvarchar](max) NULL,
 CONSTRAINT [PK_wc_audit_log] PRIMARY KEY CLUSTERED 
(
	[log_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[group]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[group](
	[group_id] [int] IDENTITY(1,1) NOT NULL,
	[group_name] [nvarchar](50) NOT NULL,
	[group_description] [nvarchar](max) NULL,
	[group_private] [int] NULL,
	[created_at] [datetime] NOT NULL CONSTRAINT [DF_groups_created_at]  DEFAULT (getdate()),
	[updated_at] [datetime] NOT NULL CONSTRAINT [DF_groups_updated_at]  DEFAULT (getdate()),
 CONSTRAINT [PK_group] PRIMARY KEY CLUSTERED 
(
	[group_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sync_settings]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[sync_settings](
	[sync_server_name] [nvarchar](100) NOT NULL,
	[sync_status] [int] NOT NULL,
	[sync_timestamp] [datetime] NOT NULL,
	[sync_frequency_hours] [int] NOT NULL,
	[sync_id] [int] IDENTITY(1,1) NOT NULL,
	[sync_job_id] [uniqueidentifier] NOT NULL,
	[sync_msg] [text] NULL,
 CONSTRAINT [PK_sync_settings_1] PRIMARY KEY CLUSTERED 
(
	[sync_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[user]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[user](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[user_email] [nvarchar](100) NULL,
	[user_nickname] [nvarchar](50) NOT NULL CONSTRAINT [DF_user_user_nickname]  DEFAULT (N'wlkmi_unknown'),
	[user_zip] [int] NOT NULL CONSTRAINT [DF_user_user_zip]  DEFAULT ((0)),
	[user_birthyear] [int] NOT NULL CONSTRAINT [DF_user_user_birthyear]  DEFAULT ((1900)),
	[user_groups] [nvarchar](1000) NULL,
	[user_stride] [int] NOT NULL CONSTRAINT [DF_user_user_stride]  DEFAULT ((24)),
	[user_weight] [int] NOT NULL CONSTRAINT [DF_user_user_weight]  DEFAULT ((0)),
	[hv_recordid] [uniqueidentifier] NOT NULL,
	[user_last_login] [datetime] NULL,
	[user_last_client_ip] [nvarchar](32) NULL,
	[user_total_steps] [bigint] NULL,
	[user_total_distance] [float] NULL,
	[user_weekly_steps] [int] NULL,
	[user_weekly_distance] [float] NULL,
	[user_weekly_calories] [float] NULL,
	[user_monthly_steps] [bigint] NULL,
	[user_annual_steps] [bigint] NULL,
	[hv_personid] [uniqueidentifier] NOT NULL,
	[user_sharing_flag] [int] NOT NULL CONSTRAINT [DF_user_user_sharing_flag]  DEFAULT ((0)),
	[hv_last_sync_time] [datetime] NULL,
	[daily_goal_steps] [int] NULL,
	[daily_goal_calories] [float] NULL,
	[daily_goal_aerobic_steps] [int] NULL,
	[daily_goal_distance] [float] NULL,
	[user_height] [int] NOT NULL CONSTRAINT [DF_user_user_height]  DEFAULT ((1)),
	[user_reg_complete_flag] [int] NOT NULL CONSTRAINT [DF_user_registration_complete]  DEFAULT ((0)),
	[updated_at] [datetime] NOT NULL CONSTRAINT [DF_user_updated_at]  DEFAULT (getdate()),
	[created_at] [datetime] NOT NULL,
	[hv_sync_entity_name] [nvarchar](100) NULL,
	[hv_sync_status] [int] NOT NULL CONSTRAINT [DF_user_sync_status]  DEFAULT ((0)),
 CONSTRAINT [PK_user] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[group_user_assoc]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[group_user_assoc](
	[group_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
	[role] [int] NOT NULL CONSTRAINT [DF_group_user_assoc_role]  DEFAULT ((0)),
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL CONSTRAINT [DF_group_user_assoc_updated_at]  DEFAULT (getdate()),
 CONSTRAINT [PK_group_user_assoc] PRIMARY KEY CLUSTERED 
(
	[group_id] ASC,
	[user_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[walk_log]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[walk_log](
	[log_id] [bigint] IDENTITY(1,1) NOT NULL,
	[log_steps] [bigint] NULL,
	[log_aerobicsteps] [bigint] NULL,
	[log_step_hourly_samples] [nvarchar](300) NULL,
	[log_aerobic_hourly_samples] [nvarchar](300) NULL,
	[log_calories] [float] NULL,
	[log_distance] [float] NULL,
	[log_weight] [int] NULL,
	[log_date] [datetime] NOT NULL,
	[log_user] [int] NOT NULL,
	[updated_at] [datetime] NOT NULL CONSTRAINT [DF_log_updated_at]  DEFAULT (getdate()),
	[hv_item_id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_log] PRIMARY KEY CLUSTERED 
(
	[log_id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_group_user_assoc_group]') AND parent_object_id = OBJECT_ID(N'[dbo].[group_user_assoc]'))
ALTER TABLE [dbo].[group_user_assoc]  WITH CHECK ADD  CONSTRAINT [FK_group_user_assoc_group] FOREIGN KEY([group_id])
REFERENCES [dbo].[group] ([group_id])
GO
ALTER TABLE [dbo].[group_user_assoc] CHECK CONSTRAINT [FK_group_user_assoc_group]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_group_user_assoc_user]') AND parent_object_id = OBJECT_ID(N'[dbo].[group_user_assoc]'))
ALTER TABLE [dbo].[group_user_assoc]  WITH CHECK ADD  CONSTRAINT [FK_group_user_assoc_user] FOREIGN KEY([user_id])
REFERENCES [dbo].[user] ([user_id])
GO
ALTER TABLE [dbo].[group_user_assoc] CHECK CONSTRAINT [FK_group_user_assoc_user]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_log_user]') AND parent_object_id = OBJECT_ID(N'[dbo].[walk_log]'))
ALTER TABLE [dbo].[walk_log]  WITH CHECK ADD  CONSTRAINT [FK_log_user] FOREIGN KEY([log_user])
REFERENCES [dbo].[user] ([user_id])
GO
ALTER TABLE [dbo].[walk_log] CHECK CONSTRAINT [FK_log_user]
