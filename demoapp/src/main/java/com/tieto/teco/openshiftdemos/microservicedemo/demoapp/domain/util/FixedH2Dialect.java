package com.tieto.teco.openshiftdemos.microservicedemo.demoapp.domain.util;

import java.sql.Types;

import org.hibernate.dialect.H2Dialect;

public class FixedH2Dialect extends H2Dialect {

    public FixedH2Dialect() {
        super();
        registerColumnType(Types.FLOAT, "real");
    }
}
