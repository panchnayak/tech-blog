Generate Self-Signed Certificate using OpenSSL

To generate a self-signed SSL certificate using the OpenSSL, complete the following steps:


1.Write down the Common Name (CN) for your SSL Certificate. The CN is the fully qualified name for the system that uses the certificate. For static DNS, use the hostname or IP address set in your Gateway Cluster (for example. 192.16.183.131 or bigopencloud.pnayak.com).

2.Run the following OpenSSL command to generate your private key and public certificate. Answer the questions and enter the Common Name when prompted.

```
openssl req -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 365 -out certificate.pem
```

3.Review the created certificate:
openssl x509 -text -noout -in bigopen-certificate.pem

4.Combine your key and certificate in a PKCS#12 (P12) bundle:

```
openssl pkcs12 -inkey key.pem -in certificate.pem -export -out certificate.p12
```

Validate your P2 file.
```
openssl pkcs12 -in certificate.p12 -noout -info
```

Or using docker 
```
docker run -v $PWD/certs:/certs -e SSL_SUBJECT=cloud.bigopen.io -e SSL_DNS=cloud.bigopen.io,bigopen.io -e SSL_IP=192.168.1.19 superseb/omgwtfssl
  
```
With Self signed certificate run the following

```
docker run -d --restart=unless-stopped -p 80:80 -p 443:443 \
  -v /opt/rancher:/var/lib/rancher \
  -v $PWD/certs/cert.pem:/etc/rancher/ssl/cert.pem \
  -v $PWD/certs/key.pem:/etc/rancher/ssl/key.pem \
  -v $PWD/certs/ca.pem:/etc/rancher/ssl/cacerts.pem \
  --privileged \
  rancher/rancher:latest
  
  
```
with Let's Encript certificate run the followinfg

```
docker run -d --restart=unless-stopped -p 80:80 -p 443:443 --privileged bigopencloud/bigopen:0.1

or

docker run -d --restart=unless-stopped -p 80:80 -p 443:443 -v /opt/rancher:/var/lib/rancher --privileged bigopencloud/bigopen:0.1 --acme-domain domain-name.io


```