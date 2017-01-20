package com.tieto.teco.openshiftdemos.microservicedemo.repository.repository;

import com.tieto.teco.openshiftdemos.microservicedemo.repository.domain.Product;

import org.springframework.data.jpa.repository.*;

import java.util.List;

/**
 * Spring Data JPA repository for the Product entity.
 */
@SuppressWarnings("unused")
public interface ProductRepository extends JpaRepository<Product,Long> {

}
