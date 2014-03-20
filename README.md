gi-security
-------------

[![Build Status](https://drone.io/github.com/GoIncremental/gi-security/status.png)](https://drone.io/github.com/GoIncremental/gi-security/latest)

This module provides a thin wrapper around passport-js, and client side user and role management.

It uses a custom HMAC authentication strategy to authenticate json api requests

It also supports session based security for human users logged in via facebook.

Testing:

Server Unit tests use Mocha, Chai

Client Unit tests use Mocha, Karma

Server Integration tests use Cucumber.js and supertest

