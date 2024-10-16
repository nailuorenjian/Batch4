-- Table: public.batch_job_execution

-- DROP TABLE IF EXISTS public.batch_job_execution;

CREATE TABLE IF NOT EXISTS public.batch_job_execution
(
    job_execution_id bigint NOT NULL,
    version bigint,
    job_instance_id bigint NOT NULL,
    create_time timestamp without time zone NOT NULL,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    status character varying(10) COLLATE pg_catalog."default",
    exit_code character varying(2500) COLLATE pg_catalog."default",
    exit_message character varying(2500) COLLATE pg_catalog."default",
    last_updated timestamp without time zone,
    job_configuration_location character varying(2500) COLLATE pg_catalog."default",
    CONSTRAINT batch_job_execution_pkey PRIMARY KEY (job_execution_id),
    CONSTRAINT job_inst_exec_fk FOREIGN KEY (job_instance_id)
    REFERENCES public.batch_job_instance (job_instance_id) MATCH SIMPLE
                           ON UPDATE NO ACTION
                           ON DELETE NO ACTION
    )

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.batch_job_execution
    OWNER to postgres;


-- Table: public.batch_job_execution_context

-- DROP TABLE IF EXISTS public.batch_job_execution_context;

CREATE TABLE IF NOT EXISTS public.batch_job_execution_context
(
    job_execution_id bigint NOT NULL,
    short_context character varying(2500) COLLATE pg_catalog."default" NOT NULL,
    serialized_context text COLLATE pg_catalog."default",
    CONSTRAINT batch_job_execution_context_pkey PRIMARY KEY (job_execution_id),
    CONSTRAINT job_exec_ctx_fk FOREIGN KEY (job_execution_id)
    REFERENCES public.batch_job_execution (job_execution_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    )

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.batch_job_execution_context
    OWNER to postgres;

-- Table: public.batch_job_execution_params

-- DROP TABLE IF EXISTS public.batch_job_execution_params;

CREATE TABLE IF NOT EXISTS public.batch_job_execution_params
(
    job_execution_id bigint NOT NULL,
    type_cd character varying(6) COLLATE pg_catalog."default" NOT NULL,
    key_name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    string_val character varying(250) COLLATE pg_catalog."default",
    date_val timestamp without time zone,
    long_val bigint,
    double_val double precision,
    identifying character(1) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT job_exec_params_fk FOREIGN KEY (job_execution_id)
    REFERENCES public.batch_job_execution (job_execution_id) MATCH SIMPLE
                       ON UPDATE NO ACTION
                       ON DELETE NO ACTION
    )

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.batch_job_execution_params
    OWNER to postgres;


-- Table: public.batch_job_instance

-- DROP TABLE IF EXISTS public.batch_job_instance;

CREATE TABLE IF NOT EXISTS public.batch_job_instance
(
    job_instance_id bigint NOT NULL,
    version bigint,
    job_name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    job_key character varying(32) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT batch_job_instance_pkey PRIMARY KEY (job_instance_id),
    CONSTRAINT job_inst_un UNIQUE (job_name, job_key)
    )

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.batch_job_instance
    OWNER to postgres;

-- Table: public.batch_step_execution

-- DROP TABLE IF EXISTS public.batch_step_execution;

CREATE TABLE IF NOT EXISTS public.batch_step_execution
(
    step_execution_id bigint NOT NULL,
    version bigint NOT NULL,
    step_name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    job_execution_id bigint NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone,
    status character varying(10) COLLATE pg_catalog."default",
    commit_count bigint,
    read_count bigint,
    filter_count bigint,
    write_count bigint,
    read_skip_count bigint,
    write_skip_count bigint,
    process_skip_count bigint,
    rollback_count bigint,
    exit_code character varying(2500) COLLATE pg_catalog."default",
    exit_message character varying(2500) COLLATE pg_catalog."default",
    last_updated timestamp without time zone,
    CONSTRAINT batch_step_execution_pkey PRIMARY KEY (step_execution_id),
    CONSTRAINT job_exec_step_fk FOREIGN KEY (job_execution_id)
    REFERENCES public.batch_job_execution (job_execution_id) MATCH SIMPLE
                         ON UPDATE NO ACTION
                         ON DELETE NO ACTION
    )

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.batch_step_execution
    OWNER to postgres;


-- Table: public.batch_step_execution_context

-- DROP TABLE IF EXISTS public.batch_step_execution_context;

CREATE TABLE IF NOT EXISTS public.batch_step_execution_context
(
    step_execution_id bigint NOT NULL,
    short_context character varying(2500) COLLATE pg_catalog."default" NOT NULL,
    serialized_context text COLLATE pg_catalog."default",
    CONSTRAINT batch_step_execution_context_pkey PRIMARY KEY (step_execution_id),
    CONSTRAINT step_exec_ctx_fk FOREIGN KEY (step_execution_id)
    REFERENCES public.batch_step_execution (step_execution_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    )

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.batch_step_execution_context
    OWNER to postgres;


-- Table: public.sys_user

-- DROP TABLE IF EXISTS public.sys_user;

CREATE TABLE IF NOT EXISTS public.sys_user
(
    id integer NOT NULL DEFAULT nextval('sys_user_id_seq'::regclass),
    user_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    sex character varying(10) COLLATE pg_catalog."default" NOT NULL,
    age character varying(10) COLLATE pg_catalog."default" NOT NULL,
    address character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT sys_user_pkey PRIMARY KEY (id),
    CONSTRAINT sys_user_user_name_key UNIQUE (user_name)
    )

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.sys_user
    OWNER to postgres;



DROP TABLE IF EXISTS people;

CREATE TABLE people  (
                         person_id SERIAL NOT NULL PRIMARY KEY,
                         first_name VARCHAR(20),
                         last_name VARCHAR(20)
);

-- Autogenerated: do not edit this file
DROP TABLE  IF EXISTS BATCH_STEP_EXECUTION_CONTEXT;
DROP TABLE  IF EXISTS BATCH_JOB_EXECUTION_CONTEXT;
DROP TABLE  IF EXISTS BATCH_STEP_EXECUTION;
DROP TABLE  IF EXISTS BATCH_JOB_EXECUTION_PARAMS;
DROP TABLE  IF EXISTS BATCH_JOB_EXECUTION;
DROP TABLE  IF EXISTS BATCH_JOB_INSTANCE;

DROP SEQUENCE  IF EXISTS BATCH_STEP_EXECUTION_SEQ ;
DROP SEQUENCE  IF EXISTS BATCH_JOB_EXECUTION_SEQ ;
DROP SEQUENCE  IF EXISTS BATCH_JOB_SEQ ;

CREATE TABLE BATCH_JOB_INSTANCE  (
                                     JOB_INSTANCE_ID BIGINT  NOT NULL PRIMARY KEY ,
                                     VERSION BIGINT ,
                                     JOB_NAME VARCHAR(100) NOT NULL,
                                     JOB_KEY VARCHAR(32) NOT NULL,
                                     constraint JOB_INST_UN unique (JOB_NAME, JOB_KEY)
) ;

CREATE TABLE BATCH_JOB_EXECUTION  (
                                      JOB_EXECUTION_ID BIGINT  NOT NULL PRIMARY KEY ,
                                      VERSION BIGINT  ,
                                      JOB_INSTANCE_ID BIGINT NOT NULL,
                                      CREATE_TIME TIMESTAMP NOT NULL,
                                      START_TIME TIMESTAMP DEFAULT NULL ,
                                      END_TIME TIMESTAMP DEFAULT NULL ,
                                      STATUS VARCHAR(10) ,
                                      EXIT_CODE VARCHAR(2500) ,
                                      EXIT_MESSAGE VARCHAR(2500) ,
                                      LAST_UPDATED TIMESTAMP,
                                      JOB_CONFIGURATION_LOCATION VARCHAR(2500) NULL,
                                      constraint JOB_INST_EXEC_FK foreign key (JOB_INSTANCE_ID)
                                          references BATCH_JOB_INSTANCE(JOB_INSTANCE_ID)
) ;

CREATE TABLE BATCH_JOB_EXECUTION_PARAMS  (
                                             JOB_EXECUTION_ID BIGINT NOT NULL ,
                                             TYPE_CD VARCHAR(6) NOT NULL ,
                                             KEY_NAME VARCHAR(100) NOT NULL ,
                                             STRING_VAL VARCHAR(250) ,
                                             DATE_VAL TIMESTAMP DEFAULT NULL ,
                                             LONG_VAL BIGINT ,
                                             DOUBLE_VAL DOUBLE PRECISION ,
                                             IDENTIFYING CHAR(1) NOT NULL ,
                                             constraint JOB_EXEC_PARAMS_FK foreign key (JOB_EXECUTION_ID)
                                                 references BATCH_JOB_EXECUTION(JOB_EXECUTION_ID)
) ;

CREATE TABLE BATCH_STEP_EXECUTION  (
                                       STEP_EXECUTION_ID BIGINT  NOT NULL PRIMARY KEY ,
                                       VERSION BIGINT NOT NULL,
                                       STEP_NAME VARCHAR(100) NOT NULL,
                                       JOB_EXECUTION_ID BIGINT NOT NULL,
                                       START_TIME TIMESTAMP NOT NULL ,
                                       END_TIME TIMESTAMP DEFAULT NULL ,
                                       STATUS VARCHAR(10) ,
                                       COMMIT_COUNT BIGINT ,
                                       READ_COUNT BIGINT ,
                                       FILTER_COUNT BIGINT ,
                                       WRITE_COUNT BIGINT ,
                                       READ_SKIP_COUNT BIGINT ,
                                       WRITE_SKIP_COUNT BIGINT ,
                                       PROCESS_SKIP_COUNT BIGINT ,
                                       ROLLBACK_COUNT BIGINT ,
                                       EXIT_CODE VARCHAR(2500) ,
                                       EXIT_MESSAGE VARCHAR(2500) ,
                                       LAST_UPDATED TIMESTAMP,
                                       constraint JOB_EXEC_STEP_FK foreign key (JOB_EXECUTION_ID)
                                           references BATCH_JOB_EXECUTION(JOB_EXECUTION_ID)
) ;

CREATE TABLE BATCH_STEP_EXECUTION_CONTEXT  (
                                               STEP_EXECUTION_ID BIGINT NOT NULL PRIMARY KEY,
                                               SHORT_CONTEXT VARCHAR(2500) NOT NULL,
                                               SERIALIZED_CONTEXT TEXT ,
                                               constraint STEP_EXEC_CTX_FK foreign key (STEP_EXECUTION_ID)
                                                   references BATCH_STEP_EXECUTION(STEP_EXECUTION_ID)
) ;

CREATE TABLE BATCH_JOB_EXECUTION_CONTEXT  (
                                              JOB_EXECUTION_ID BIGINT NOT NULL PRIMARY KEY,
                                              SHORT_CONTEXT VARCHAR(2500) NOT NULL,
                                              SERIALIZED_CONTEXT TEXT ,
                                              constraint JOB_EXEC_CTX_FK foreign key (JOB_EXECUTION_ID)
                                                  references BATCH_JOB_EXECUTION(JOB_EXECUTION_ID)
) ;

CREATE SEQUENCE BATCH_STEP_EXECUTION_SEQ MAXVALUE 9223372036854775807 NO CYCLE;
CREATE SEQUENCE BATCH_JOB_EXECUTION_SEQ MAXVALUE 9223372036854775807 NO CYCLE;
CREATE SEQUENCE BATCH_JOB_SEQ MAXVALUE 9223372036854775807 NO CYCLE;
