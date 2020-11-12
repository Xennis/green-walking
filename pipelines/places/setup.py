import setuptools

setuptools.setup(
    name="greenwalking",
    install_requires=[
        "beautifulsoup4==4.9.3",
        "google-cloud-firestore==1.9.0",
        "sparqlwrapper==1.8.5",
        "sqlitedict==1.7.0"
    ],
    packages=setuptools.find_namespace_packages(),
)
