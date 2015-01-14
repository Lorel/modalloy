# MODALLOY : Generate alloy model of a Rails app

This program generate an Alloy model of a rails application using the specific Alloy DSL provided by Arby

### INSTALL DEPENDENCIES
```
$ bundle install
```

Use ```--path vendor/bundle``` option to install locally

Modalloy use Alloy through Arby, and needs Java 1.6 (or higher) and environment variable JAVA_HOME properly set

### RUN

Run analyze of model from FatFreeCRM

```
$ bundle exec ruby app.rb
```

Run analyze of model from a Rails app

```
$ bundle exec ruby app.rb relative/path/to/models/directory
```

The execution print Alloy model on stdout