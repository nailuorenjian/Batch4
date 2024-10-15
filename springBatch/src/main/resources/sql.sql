CREATE TABLE `batch_job_instance` (
                                      `JOB_INSTANCE_ID` bigint(20) NOT NULL COMMENT '主键。作业实例ID编号，根据BATCH_JOB_SEQ自动生成',
                                      `VERSION` bigint(20) DEFAULT NULL COMMENT '版本号',
                                      `JOB_NAME` varchar(100) NOT NULL COMMENT '作业名称。即在配置文件中定义的 job id 字段的内容',
                                      `JOB_KEY` varchar(32) NOT NULL COMMENT '作业标识。根据作业参数序列化生成的标识。需要注意通过 JOB_NAME +JOB_KEY  能够唯一区分一个作业实例。如果是同一个Job，则JOB KEY一定不能相通，即作业参数不能相同。如果不是同一个JOB则KEY可以相同，也就说可以是同一个作业参数',
                                      PRIMARY KEY (`JOB_INSTANCE_ID`),
                                      UNIQUE KEY `JOB_INST_UN` (`JOB_NAME`,`JOB_KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='作业实例表。用于存放Job的实例信息';


CREATE TABLE `batch_job_execution` (
                                       `JOB_EXECUTION_ID` bigint(20) NOT NULL COMMENT '主键。作业执行器ID编号',
                                       `VERSION` bigint(20) DEFAULT NULL COMMENT '版本号',
                                       `JOB_INSTANCE_ID` bigint(20) NOT NULL COMMENT '作业实例ID编号',
                                       `CREATE_TIME` datetime NOT NULL COMMENT '作业执行器创建时间',
                                       `START_TIME` datetime DEFAULT NULL COMMENT '作业执行器开始执行时间',
                                       `END_TIME` datetime DEFAULT NULL COMMENT '作业执行器结束时间',
                                       `STATUS` varchar(10) DEFAULT NULL COMMENT '作业执行器的状态。如：COMPLETED成功结束,STARTING运行时,STARTED运行时,STOPPING,STOPTED,FAILED执行失败,ABANDED,UNKNOWN。这些状态在类org.springframework.batch.core.ExitStatus中',
                                       `EXIT_CODE` varchar(2500) DEFAULT NULL COMMENT '作业执行器退出编码。如：UNKNOWN,EXEXCUTION,COMPLETED,NOOP,FAILED,STOPPED。这些状态在类org.springframework.batch.core.ExitStatus中定义的',
                                       `EXIT_MESSAGE` varchar(2500) DEFAULT NULL COMMENT '作业执行器退出描述，详细描述退出的信息，如果发生异常，通常包含异常的堆栈信息',
                                       `LAST_UPDATED` datetime DEFAULT NULL COMMENT '本条记录上次更新时间',
                                       `JOB_CONFIGURATION_LOCATION` varchar(2500) DEFAULT NULL COMMENT 'Job本地配置信息',
                                       PRIMARY KEY (`JOB_EXECUTION_ID`),
                                       KEY `JOB_INST_EXEC_FK` (`JOB_INSTANCE_ID`),
                                       CONSTRAINT `JOB_INST_EXEC_FK` FOREIGN KEY (`JOB_INSTANCE_ID`) REFERENCES `batch_job_instance` (`JOB_INSTANCE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='作业执行器表。用于存放当前作业的执行信息，比如创建时间。执行开始时间，执行结束时间，执行的哪个Job实例，执行状态等';


CREATE TABLE `batch_job_execution_params` (
                                              `JOB_EXECUTION_ID` bigint(20) NOT NULL COMMENT '外键，作业执行器ID编号。一个作业实例可能会有多行参数记录，主要根据参数的个数决定的',
                                              `TYPE_CD` varchar(6) NOT NULL COMMENT '参数类型，可能是如下四种当中的一种：date、string、long、double',
                                              `KEY_NAME` varchar(100) NOT NULL COMMENT '参数的名字',
                                              `STRING_VAL` varchar(250) DEFAULT NULL COMMENT '如果参数是String类型此处存放是String类型的参数值',
                                              `DATE_VAL` datetime DEFAULT NULL COMMENT '如果参数是date类型，此处存放的是date类型的参数值',
                                              `LONG_VAL` bigint(20) DEFAULT NULL COMMENT '如果参数是long类型，此处存放是long类型的参数值',
                                              `DOUBLE_VAL` double DEFAULT NULL COMMENT '如果参数是double类型，则此处存放double类型的参数值',
                                              `IDENTIFYING` char(1) NOT NULL COMMENT '是否mD5 trueMD5（用于标识作业参数是否标识作业实例）',
                                              KEY `JOB_EXEC_PARAMS_FK` (`JOB_EXECUTION_ID`),
                                              CONSTRAINT `JOB_EXEC_PARAMS_FK` FOREIGN KEY (`JOB_EXECUTION_ID`) REFERENCES `batch_job_execution` (`JOB_EXECUTION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='作业参数表。用于存放每个Job执行时候的参数信息，该参数实际上是对应Job实例的';


CREATE TABLE `batch_step_execution` (
                                        `STEP_EXECUTION_ID` bigint(20) NOT NULL COMMENT '主键，作业步实例ID编号',
                                        `VERSION` bigint(20) NOT NULL COMMENT '版本',
                                        `STEP_NAME` varchar(100) NOT NULL COMMENT '操作步的名字',
                                        `JOB_EXECUTION_ID` bigint(20) NOT NULL COMMENT '外键。操作执行器ID',
                                        `START_TIME` datetime NOT NULL COMMENT '操作步执行器开始执行时间',
                                        `END_TIME` datetime DEFAULT NULL COMMENT '操作步执行器结束时间',
                                        `STATUS` varchar(10) DEFAULT NULL COMMENT '操作步执行器执行状态，如：COMPLETED,STARTING,STARTED,STOPPING,STOPPED,FAILED,ABANDED,UNKNOWN。这些状态在类：org.springframework.batch.core.ExitStatus中',
                                        `COMMIT_COUNT` bigint(20) DEFAULT NULL COMMENT '事务提交次数',
                                        `READ_COUNT` bigint(20) DEFAULT NULL COMMENT '读数据的次数',
                                        `FILTER_COUNT` bigint(20) DEFAULT NULL COMMENT '过滤掉的数据次数',
                                        `WRITE_COUNT` bigint(20) DEFAULT NULL COMMENT '写数据的次数',
                                        `READ_SKIP_COUNT` bigint(20) DEFAULT NULL COMMENT '读数据跳过的次数',
                                        `WRITE_SKIP_COUNT` bigint(20) DEFAULT NULL COMMENT '写数据跳过的次',
                                        `PROCESS_SKIP_COUNT` bigint(20) DEFAULT NULL COMMENT '处理数据跳过的次数',
                                        `ROLLBACK_COUNT` bigint(20) DEFAULT NULL COMMENT '事务回滚次数',
                                        `EXIT_CODE` varchar(2500) DEFAULT NULL COMMENT '操作步执行器的退出编码。如：UNKNOWN,EXEXCUTION,COMPLETED,NOOP,FAILED,STOPPED。这些状态在类org.springframework.batch.core.ExitStatus中定义的',
                                        `EXIT_MESSAGE` varchar(2500) DEFAULT NULL COMMENT '操作步执行器退出描述，详细描述退出的信息。如异常的堆栈信息等',
                                        `LAST_UPDATED` datetime DEFAULT NULL COMMENT '本条记录上次更新时间',
                                        PRIMARY KEY (`STEP_EXECUTION_ID`),
                                        KEY `JOB_EXEC_STEP_FK` (`JOB_EXECUTION_ID`),
                                        CONSTRAINT `JOB_EXEC_STEP_FK` FOREIGN KEY (`JOB_EXECUTION_ID`) REFERENCES `batch_job_execution` (`JOB_EXECUTION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='作业步执行器表。用于存放每个Step执行器的信息，比如作业步的开始时间、执行完成时间、执行状态、读/写次数、跳过次数等';


CREATE TABLE `batch_step_execution_context` (
                                                `STEP_EXECUTION_ID` bigint(20) NOT NULL COMMENT '外键。操作步执行器ID编号',
                                                `SHORT_CONTEXT` varchar(2500) NOT NULL COMMENT '作业执行器上下文字符串格式',
                                                `SERIALIZED_CONTEXT` text COMMENT '序列化的作业执行器上下文',
                                                PRIMARY KEY (`STEP_EXECUTION_ID`),
                                                CONSTRAINT `STEP_EXEC_CTX_FK` FOREIGN KEY (`STEP_EXECUTION_ID`) REFERENCES `batch_step_execution` (`STEP_EXECUTION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='作业步执行上下文表。用于存放每个作业步的上下文信息';


CREATE TABLE `batch_job_execution_context` (
                                               `JOB_EXECUTION_ID` bigint(20) NOT NULL COMMENT '外键。作业执行器ID编号',
                                               `SHORT_CONTEXT` varchar(2500) NOT NULL COMMENT '作业执行器上下文字符串格式',
                                               `SERIALIZED_CONTEXT` text COMMENT '序列化的作业执行器上下文',
                                               PRIMARY KEY (`JOB_EXECUTION_ID`),
                                               CONSTRAINT `JOB_EXEC_CTX_FK` FOREIGN KEY (`JOB_EXECUTION_ID`) REFERENCES `batch_job_execution` (`JOB_EXECUTION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='作业执行上下文表。用于存放作业执行器上下文的信息';


CREATE TABLE `batch_job_execution_seq` (
                                           `ID` bigint(20) NOT NULL,
                                           `UNIQUE_KEY` char(1) NOT NULL,
                                           UNIQUE KEY `UNIQUE_KEY_UN` (`UNIQUE_KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='作业执行器序列表。用于给表BATCH_JOB_EXECUTION和BATCH_JOB_EXECUTION_CONTEXT提供主键';


CREATE TABLE `batch_job_seq` (
                                 `ID` bigint(20) NOT NULL,
                                 `UNIQUE_KEY` char(1) NOT NULL,
                                 UNIQUE KEY `UNIQUE_KEY_UN` (`UNIQUE_KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='作业序列表。用于给表BATCH_JOB_INSTANCE和BATCH_JOB_EXECUTION_PARAMS提供主键';



CREATE TABLE `batch_step_execution_seq` (
                                            `ID` bigint(20) NOT NULL,
                                            `UNIQUE_KEY` char(1) NOT NULL,
                                            UNIQUE KEY `UNIQUE_KEY_UN` (`UNIQUE_KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='作业步序列表。用于给表BATCH_STEP_EXECUTION和BATCH_STEP_EXECUTION_CONTEXT提供主键';


-- hsqldb
-- DROP TABLE people IF EXISTS;
-- CREATE TABLE people  (
--     person_id BIGINT IDENTITY NOT NULL PRIMARY KEY,
--     first_name VARCHAR(20),
--     last_name VARCHAR(20)
-- );

-- mysql 不能有 IDENTITY
-- DROP TABLE IF EXISTS `people`;
-- CREATE TABLE `people` (
--   `person_id` bigint(20) NOT NULL AUTO_INCREMENT,
--   `first_name` varchar(20) COLLATE utf8_bin DEFAULT NULL,
--   `last_name` varchar(20) COLLATE utf8_bin DEFAULT NULL,
--   PRIMARY KEY (`person_id`)
-- ) /*!50100 TABLESPACE `innodb_system` */ ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


INSERT INTO BATCH_STEP_EXECUTION_SEQ (ID, UNIQUE_KEY) SELECT
    *
FROM
    (
        SELECT
            0 AS ID,
            '0' AS UNIQUE_KEY
    ) AS tmp
WHERE
    NOT EXISTS (
            SELECT
                *
            FROM
                BATCH_STEP_EXECUTION_SEQ
        );

INSERT INTO BATCH_JOB_EXECUTION_SEQ (ID, UNIQUE_KEY) SELECT
    *
FROM
    (
        SELECT
            0 AS ID,
            '0' AS UNIQUE_KEY
    ) AS tmp
WHERE
    NOT EXISTS (
            SELECT
                *
            FROM
                BATCH_JOB_EXECUTION_SEQ
        );

INSERT INTO BATCH_JOB_SEQ (ID, UNIQUE_KEY) SELECT
    *
FROM
    (
        SELECT
            0 AS ID,
            '0' AS UNIQUE_KEY
    ) AS tmp
WHERE
    NOT EXISTS (SELECT * FROM BATCH_JOB_SEQ);
