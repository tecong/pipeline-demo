package com.tieto.teco.openshiftdemos.microservicedemo.repository.cucumber.stepdefs;

import com.tieto.teco.openshiftdemos.microservicedemo.repository.RepositoryApp;

import org.springframework.boot.test.SpringApplicationContextLoader;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.ResultActions;

@WebAppConfiguration
@ContextConfiguration(classes = RepositoryApp.class, loader = SpringApplicationContextLoader.class)
public abstract class StepDefs {

    protected ResultActions actions;

}
