# [ssl_cert_checker](https://github.com/YoyaYOSHIDA/ssl_cert_checker)

Checks validity and lifetimes of SSL certificates of your web servers.

Based on: [do_not_forget_the_expire_date_of_ssl_ certificate_of_your_web_server.md](https://gist.github.com/YoyaYOSHIDA/91e432bd447d2f074af321d7160044e5/edit)

# How to use

## List URLs

List URLs of web servers in [servers.list](./servers.list) .

Example:

```
myserver1.com
myserver2.net
# Comment lines can be input.
myserver3.co.uk
```

## Run script

Simply execute for Linux:

```bash
./ssl_cert_checker_linux.sh
```

Or for MacOS:

```
./ssl_cert_checker_macos.sh
```

# Output

The output will be for example:

```
myserver1.com,HttpsUnavailable,00000000
myserver2.com,Valid,20210503
myserver3.com,Expired,20171005
myserver4.com,ServerUnreachableVia443,00000000
```

The output syntax is `<URL>,<Valid | Expired | HttpsUnavailable | ServerUnreachableVia443>,<Last date of certificate lifetime>` .

-   `Valid`
    -   HTTPS is available and SSL certificate is valid
-   `Expired`
    -   HTTPS is available but SSL certificate is expired
-   `HttpsUnavailable`
    -   The server might accept only HTTP
-   `ServerUnreachableVia443`
    -   The server is unreachable via 443/TCP

Note that you don't need to consider whether HTTPS is available or not (in case of HTTPS is unavailable, the output will return `Unavailable`). 

# Appendix

You can use this script by modifying a little and running on a regular basis by cron and send the result to Slack if the expire date of an SSL certificate is comming not to forget it.
