Scaler
------
#### Scaler is a simple Sinatra app for managing AWS autoscaling launch configurations, groups and scheduled actions

Usage
------

### Installation

```
$ git clone https://github.com/applicaster/scaler.git
```

```
$ bundle install
```

### Configuration

The following Environment variables required by **Scaler**

```SCALER_TZ``` The default TimeZone 

```SCALER_USER``` Username for http basic authentication

```SCALER_PASS``` Password for http basic authentication

```AWS_ACCESS_KEY_ID``` AWS access key ID

```AWS_SECRET_ACCESS_KEY``` AWS secret access key

### Running the App

On your local machine just type ```bundle exec rackup```

If you want to deploy it to remote server I suggest using [Nginx + Unicorn](https://github.com/zzak/sinatra-recipes/blob/master/deployment/nginx_proxied_to_unicorn.md) setup
