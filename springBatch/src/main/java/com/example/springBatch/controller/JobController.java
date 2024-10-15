package com.example.springBatch.controller;

import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.JobParametersBuilder;
import org.springframework.batch.core.configuration.JobRegistry;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.batch.core.launch.NoSuchJobException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;

@RestController
public class JobController {
    @Autowired
    private JobLauncher jobLauncher;
    @Autowired
    private Job job;

    @GetMapping("/doJob")
    public void doJob(){
        try {
            // 同一个job执行多次，由于job定义一样，则无法区分jobInstance，所以增加jobParameter用于区分
            JobParametersBuilder jobParametersBuilder = new JobParametersBuilder();
            jobParametersBuilder.addDate("jobDate", new Date());

            // 执行一个批处理任务
            jobLauncher.run(job, jobParametersBuilder.toJobParameters());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

