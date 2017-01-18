package com.tieto.teco.openshiftdemos.microservicedemo.demoapp.repository;

import com.tieto.teco.openshiftdemos.microservicedemo.demoapp.domain.Authority;

import org.springframework.data.jpa.repository.JpaRepository;

/**
 * Spring Data JPA repository for the Authority entity.
 */
public interface AuthorityRepository extends JpaRepository<Authority, String> {
}
