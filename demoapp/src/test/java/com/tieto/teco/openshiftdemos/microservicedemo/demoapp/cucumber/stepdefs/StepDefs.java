package com.tieto.teco.openshiftdemos.microservicedemo.demoapp.cucumber.stepdefs;

import com.tieto.teco.openshiftdemos.microservicedemo.demoapp.DemoappApp;

import org.springframework.boot.test.SpringApplicationContextLoader;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.ResultActions;

@WebAppConfiguration
@ContextConfiguration(classes = DemoappApp.class, loader = SpringApplicationContextLoader.class)
public abstract class StepDefs {

    protected ResultActions actions;

}
