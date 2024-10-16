package com.example.springBatch.config;


import com.example.springBatch.domain.BuUser;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.batch.core.configuration.annotation.JobBuilderFactory;
import org.springframework.batch.core.configuration.annotation.StepBuilderFactory;
import org.springframework.batch.item.ItemReader;
import org.springframework.batch.item.ItemWriter;
import org.springframework.batch.item.database.BeanPropertyItemSqlParameterSourceProvider;
import org.springframework.batch.item.database.JdbcBatchItemWriter;
import org.springframework.batch.item.file.FlatFileItemReader;
import org.springframework.batch.item.file.mapping.BeanWrapperFieldSetMapper;
import org.springframework.batch.item.file.mapping.DefaultLineMapper;
import org.springframework.batch.item.file.transform.DelimitedLineTokenizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

import javax.sql.DataSource;
import java.io.FileNotFoundException;

@Configuration
@EnableBatchProcessing
public class BatchConfig {

    /**
     * 用来读取数据
     */
    @Bean
    public ItemReader<BuUser> reader() {
        // FlatFileItemReader是一个用来加载文件的itemReader
        FlatFileItemReader<BuUser> reader = new FlatFileItemReader<>();
        // 跳过第一行的标题
        reader.setLinesToSkip(1);
        //设置csv的位置
        reader.setResource(new ClassPathResource("data.csv"));
        // 设置每一行的数据信息
        reader.setLineMapper(new DefaultLineMapper<BuUser>() {{
            setLineTokenizer(new DelimitedLineTokenizer() {{
                // 配置字段
                setNames("userName", "sex", "age", "address");
                // 配置列与列之间的间隔符，会通过间隔符对每一行进行切分
                setDelimiter(",");
            }});
            // 设置要映射的实体类属性
            setFieldSetMapper(new BeanWrapperFieldSetMapper<BuUser>() {{
                setTargetType(BuUser.class);
            }});
        }});
        return reader;
    }

    /**
     * 用来输出数据
     */

    @Bean
    public ItemWriter<BuUser> writer(DataSource dataSource) {
        // 通过JDBC写入数据库中
        JdbcBatchItemWriter<BuUser> writer = new JdbcBatchItemWriter<>();
        writer.setDataSource(dataSource);
        // setItemSqlParameterSourceProvider表示将实体类中的属性和占位符一一映射
        writer.setItemSqlParameterSourceProvider(
                new BeanPropertyItemSqlParameterSourceProvider<>()
        );
        // 设置要执行批处理的SQL语句，其中占位符的写法时 `:属性名`
        writer.setSql("insert into sys_user(user_name, sex, age, address)" + "values(:userName, :sex, :age, :address)");
        return writer;
    }

    /**
     * 配置一个step
     */
    @Bean
    public Step csvStep(
            StepBuilderFactory stepBuilderFactory,
            ItemReader<BuUser> reader,
            ItemWriter<BuUser> writer) {
        return stepBuilderFactory.get("cvsStep")
                // 批处理每次提交10条数据，就是每请求一次，提交一次
                .<BuUser, BuUser>chunk(10)
                // 给step绑定 reader
                .reader(reader)
                // 给step绑定 writer
                .writer(writer)
                .faultTolerant()
                // 设定一个我们允许的这个step跳过的异常的数量，加入我们设定为3，则当这个step运行时，只要出现的异常数目不超过3
                .skipLimit(3)
                // 指定我们可以跳过的异常，因为有些异常的出现，我们是可以忽略的
                .skip(Exception.class)
                // 出现这个异常我们不想跳过，因此这种异常出现一次时，计数器就会加一，直到达到上限
                .noSkip(FileNotFoundException.class)
                .build();
    }

    /**
     * 配置一个要执行的Job任务，包含一个或多个Step
     */
    @Bean
    public Job cvsJob(JobBuilderFactory jobBuilderFactory, Step step) {
        // 为job起名为cvsJob
        return jobBuilderFactory.get("cvsJob").start(step).build();
    }

}




