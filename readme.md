# MODALLOY : Generate alloy model of a Rails app

This program generate an Alloy model of a rails application using the specific Alloy DSL provided by αRby

### INSTALL DEPENDENCIES
```
$ bundle install
```

Use ```--path vendor/bundle``` option to install locally

Modalloy use Alloy through αRby, and needs Java 1.6 (or higher) and environment variable JAVA_HOME properly set

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

### ABOUT

This project is based on the study [Bounded Verification of Ruby on Rails Data Models](http://www.cs.ucsb.edu/~bultan/publications/issta11.pdf).

It tries to implement this study by using [αRby](people.csail.mit.edu/aleks/website/papers/abz14-arby.pdf)(http://people.csail.mit.edu/aleks/website/arby/).