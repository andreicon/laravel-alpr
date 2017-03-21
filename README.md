# laravel-alpr

A simple Automatic License Plate Recognition imlpementation with laravel running as a docker container

Getting / will render a form to upload a photo containing a license plate

Posting to / will return the image and a license plate detected or NULL on failure.

## Usage

Clone:

```bash
git clone https://github.com/andreicon/laravel-alpr
cd laravel-alpr
```

Build:

```bash
docker build . -t andreicon/alpr
```

Run:

```bash
docker run -d -p 8000:8000 andreicon/laravel-alpr
```

## TODO:

- modify existing licenseplate class and return all data from alpr call
- ability to parse video stream and add plates to a datastore
