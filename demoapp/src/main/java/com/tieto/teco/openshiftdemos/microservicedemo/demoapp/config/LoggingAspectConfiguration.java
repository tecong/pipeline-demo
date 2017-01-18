package com.tieto.teco.openshiftdemos.microservicedemo.demoapp.config;

import com.tieto.teco.openshiftdemos.microservicedemo.demoapp.aop.logging.LoggingAspect;
import org.springframework.context.annotation.*;

@Configuration
@EnableAspectJAutoProxy
public class LoggingAspectConfiguration {

    @Bean
    @Profile(Constants.SPRING_PROFILE_DEVELOPMENT)
    public LoggingAspect loggingAspect() {
        return new LoggingAspect();
    }
}
