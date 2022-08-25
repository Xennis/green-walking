String fuuRaw = '''{
    "version": 8,
    "name": "greenwalking-outdoors",
    "metadata": {
        "mapbox:type": "default",
        "mapbox:origin": "outdoors-v11",
        "mapbox:sdk-support": {
            "android": "9.3.0",
            "ios": "5.10.0",
            "js": "1.10.0"
        },
        "mapbox:autocomposite": true,
        "mapbox:groups": {
            "Terrain, terrain-labels": {
                "name": "Terrain, terrain-labels",
                "collapsed": false
            },
            "Transit, transit-labels": {
                "name": "Transit, transit-labels",
                "collapsed": false
            },
            "Administrative boundaries, admin": {
                "name": "Administrative boundaries, admin",
                "collapsed": false
            },
            "Land & water, built": {
                "name": "Land & water, built",
                "collapsed": false
            },
            "Transit, bridges": {
                "name": "Transit, bridges",
                "collapsed": false
            },
            "Terrain, surface": {
                "name": "Terrain, surface",
                "collapsed": false
            },
            "Buildings, building-labels": {
                "name": "Buildings, building-labels",
                "collapsed": false
            },
            "Transit, surface": {
                "name": "Transit, surface",
                "collapsed": false
            },
            "Land & water, land": {
                "name": "Land & water, land",
                "collapsed": false
            },
            "Road network, bridges": {
                "name": "Road network, bridges",
                "collapsed": false
            },
            "Road network, tunnels": {
                "name": "Road network, tunnels",
                "collapsed": false
            },
            "Road network, road-labels": {
                "name": "Road network, road-labels",
                "collapsed": false
            },
            "Buildings, built": {
                "name": "Buildings, built",
                "collapsed": false
            },
            "Natural features, natural-labels": {
                "name": "Natural features, natural-labels",
                "collapsed": false
            },
            "Road network, surface": {
                "name": "Road network, surface",
                "collapsed": false
            },
            "Walking, cycling, etc., barriers-bridges": {
                "name": "Walking, cycling, etc., barriers-bridges",
                "collapsed": false
            },
            "Place labels, place-labels": {
                "name": "Place labels, place-labels",
                "collapsed": false
            },
            "Transit, ferries": {
                "name": "Transit, ferries",
                "collapsed": false
            },
            "Transit, elevated": {
                "name": "Transit, elevated",
                "collapsed": false
            },
            "Point of interest labels, poi-labels": {
                "name": "Point of interest labels, poi-labels",
                "collapsed": false
            },
            "Walking, cycling, etc., tunnels": {
                "name": "Walking, cycling, etc., tunnels",
                "collapsed": false
            },
            "Terrain, land": {
                "name": "Terrain, land",
                "collapsed": false
            },
            "Road network, tunnels-case": {
                "name": "Road network, tunnels-case",
                "collapsed": false
            },
            "Walking, cycling, etc., walking-cycling-labels": {
                "name": "Walking, cycling, etc., walking-cycling-labels",
                "collapsed": false
            },
            "Walking, cycling, etc., surface": {
                "name": "Walking, cycling, etc., surface",
                "collapsed": false
            },
            "Transit, built": {
                "name": "Transit, built",
                "collapsed": false
            },
            "Road network, surface-icons": {
                "name": "Road network, surface-icons",
                "collapsed": false
            },
            "Land & water, water": {
                "name": "Land & water, water",
                "collapsed": false
            },
            "Transit, ferry-aerialway-labels": {
                "name": "Transit, ferry-aerialway-labels",
                "collapsed": false
            }
        }
    },
    "center": [
        9.970331734401498,
        53.57239348983052
    ],
    "zoom": 15.103125335939046,
    "bearing": 0,
    "pitch": 0,
    "sources": {
        "composite": {
            "url": "mapbox://mapbox.mapbox-streets-v8,mapbox.mapbox-terrain-v2",
            "type": "vector"
        }
    },
    "sprite": "mapbox://sprites/xennis/ckfbioyul1iln1ap0pm5hrcgy/3nae2cnmmvrdazx877w1wcuez",
    "glyphs": "mapbox://fonts/xennis/{fontstack}/{range}.pbf",
    "layers": [
        {
            "id": "land",
            "type": "background",
            "layout": {},
            "paint": {
                "background-color": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    11,
                    "hsl(35, 25%, 93%)",
                    13,
                    "hsl(35, 9%, 91%)"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "land-and-water",
                "mapbox:group": "Land & water, land"
            }
        },
        {
            "id": "landcover-outdoors",
            "type": "fill",
            "source": "composite",
            "source-layer": "landcover",
            "maxzoom": 12,
            "layout": {},
            "paint": {
                "fill-color": [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "snow",
                    "hsl(35, 11%, 100%)",
                    "hsl(81, 37%, 83%)"
                ],
                "fill-opacity": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    2,
                    0.3,
                    12,
                    0
                ],
                "fill-antialias": false
            },
            "metadata": {
                "mapbox:featureComponent": "land-and-water",
                "mapbox:group": "Land & water, land"
            }
        },
        {
            "minzoom": 5,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "land-and-water",
                "mapbox:group": "Land & water, land"
            },
            "filter": [
                "==",
                [
                    "get",
                    "class"
                ],
                "national_park"
            ],
            "type": "fill",
            "source": "composite",
            "id": "national-park",
            "paint": {
                "fill-color": "hsl(99, 57%, 75%)",
                "fill-opacity": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    5,
                    0,
                    6,
                    0.75,
                    10,
                    0.35
                ]
            },
            "source-layer": "landuse_overlay"
        },
        {
            "minzoom": 9,
            "layout": {
                "line-cap": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "land-and-water",
                "mapbox:group": "Land & water, land"
            },
            "filter": [
                "==",
                [
                    "get",
                    "class"
                ],
                "national_park"
            ],
            "type": "line",
            "source": "composite",
            "id": "national-park_tint-band",
            "paint": {
                "line-color": "hsl(99, 58%, 70%)",
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.4
                    ],
                    [
                        "zoom"
                    ],
                    9,
                    1,
                    14,
                    8
                ],
                "line-offset": [
                    "interpolate",
                    [
                        "exponential",
                        1.4
                    ],
                    [
                        "zoom"
                    ],
                    9,
                    0,
                    14,
                    -2.5
                ],
                "line-opacity": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    9,
                    0,
                    10,
                    0.75
                ],
                "line-blur": 3
            },
            "source-layer": "landuse_overlay"
        },
        {
            "minzoom": 5,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "land-and-water",
                "mapbox:group": "Land & water, land"
            },
            "filter": [
                "match",
                [
                    "get",
                    "class"
                ],
                [
                    "park",
                    "airport",
                    "glacier",
                    "pitch",
                    "sand",
                    "facility"
                ],
                true,
                [
                    "agriculture",
                    "wood",
                    "grass",
                    "scrub"
                ],
                true,
                "cemetery",
                true,
                "school",
                true,
                "hospital",
                true,
                false
            ],
            "type": "fill",
            "source": "composite",
            "id": "landuse",
            "paint": {
                "fill-color": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        "park",
                        [
                            "match",
                            [
                                "get",
                                "type"
                            ],
                            [
                                "garden",
                                "playground",
                                "zoo"
                            ],
                            "hsl(99, 35%, 73%)",
                            "hsl(99, 57%, 75%)"
                        ],
                        "airport",
                        "hsl(230, 12%, 92%)",
                        "cemetery",
                        "hsl(81, 26%, 81%)",
                        "glacier",
                        "hsl(196, 70%, 90%)",
                        "hospital",
                        "hsl(340, 21%, 88%)",
                        "pitch",
                        "hsl(99, 58%, 70%)",
                        "sand",
                        "hsl(65, 46%, 89%)",
                        "school",
                        "hsl(50, 46%, 82%)",
                        "agriculture",
                        "hsl(81, 26%, 81%)",
                        [
                            "wood",
                            "grass",
                            "scrub"
                        ],
                        "hsl(81, 25%, 66%)",
                        "hsl(35, 13%, 86%)"
                    ],
                    16,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        "park",
                        [
                            "match",
                            [
                                "get",
                                "type"
                            ],
                            [
                                "garden",
                                "playground",
                                "zoo"
                            ],
                            "hsl(99, 35%, 73%)",
                            "hsl(99, 57%, 75%)"
                        ],
                        "airport",
                        "hsl(230, 26%, 90%)",
                        "cemetery",
                        "hsl(81, 26%, 81%)",
                        "glacier",
                        "hsl(196, 70%, 90%)",
                        "hospital",
                        "hsl(340, 32%, 90%)",
                        "pitch",
                        "hsl(99, 58%, 70%)",
                        "sand",
                        "hsl(65, 46%, 89%)",
                        "school",
                        "hsl(50, 46%, 82%)",
                        "agriculture",
                        "hsl(81, 26%, 81%)",
                        [
                            "wood",
                            "grass",
                            "scrub"
                        ],
                        "hsl(81, 25%, 66%)",
                        "hsl(35, 13%, 86%)"
                    ]
                ],
                "fill-opacity": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    5,
                    0,
                    6,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "agriculture",
                            "wood",
                            "grass",
                            "scrub"
                        ],
                        0,
                        "glacier",
                        0.5,
                        1
                    ],
                    15,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        "agriculture",
                        0.75,
                        [
                            "wood",
                            "glacier"
                        ],
                        0.5,
                        "grass",
                        0.4,
                        "scrub",
                        0.2,
                        1
                    ]
                ]
            },
            "source-layer": "landuse"
        },
        {
            "minzoom": 15,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "land-and-water",
                "mapbox:group": "Land & water, land"
            },
            "filter": [
                "==",
                [
                    "get",
                    "class"
                ],
                "pitch"
            ],
            "type": "line",
            "source": "composite",
            "id": "pitch-outline",
            "paint": {
                "line-color": "hsl(81, 33%, 86%)"
            },
            "source-layer": "landuse"
        },
        {
            "id": "waterway-shadow",
            "type": "line",
            "source": "composite",
            "source-layer": "waterway",
            "minzoom": 8,
            "layout": {
                "line-cap": [
                    "step",
                    [
                        "zoom"
                    ],
                    "butt",
                    11,
                    "round"
                ],
                "line-join": "round"
            },
            "paint": {
                "line-color": "hsl(215, 84%, 69%)",
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.3
                    ],
                    [
                        "zoom"
                    ],
                    9,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "canal",
                            "river"
                        ],
                        0.1,
                        0
                    ],
                    20,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "canal",
                            "river"
                        ],
                        8,
                        3
                    ]
                ],
                "line-translate": [
                    "interpolate",
                    [
                        "exponential",
                        1.2
                    ],
                    [
                        "zoom"
                    ],
                    7,
                    [
                        "literal",
                        [
                            0,
                            0
                        ]
                    ],
                    16,
                    [
                        "literal",
                        [
                            -1,
                            -1
                        ]
                    ]
                ],
                "line-translate-anchor": "viewport",
                "line-opacity": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    8,
                    0,
                    8.5,
                    1
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "land-and-water",
                "mapbox:group": "Land & water, water"
            }
        },
        {
            "id": "water-shadow",
            "type": "fill",
            "source": "composite",
            "source-layer": "water",
            "layout": {},
            "paint": {
                "fill-color": "hsl(215, 84%, 69%)",
                "fill-translate": [
                    "interpolate",
                    [
                        "exponential",
                        1.2
                    ],
                    [
                        "zoom"
                    ],
                    7,
                    [
                        "literal",
                        [
                            0,
                            0
                        ]
                    ],
                    16,
                    [
                        "literal",
                        [
                            -1,
                            -1
                        ]
                    ]
                ],
                "fill-translate-anchor": "viewport"
            },
            "metadata": {
                "mapbox:featureComponent": "land-and-water",
                "mapbox:group": "Land & water, water"
            }
        },
        {
            "id": "waterway",
            "type": "line",
            "source": "composite",
            "source-layer": "waterway",
            "minzoom": 8,
            "layout": {
                "line-cap": [
                    "step",
                    [
                        "zoom"
                    ],
                    "butt",
                    11,
                    "round"
                ],
                "line-join": "round"
            },
            "paint": {
                "line-color": "hsl(196, 80%, 70%)",
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.3
                    ],
                    [
                        "zoom"
                    ],
                    9,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "canal",
                            "river"
                        ],
                        0.1,
                        0
                    ],
                    20,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "canal",
                            "river"
                        ],
                        8,
                        3
                    ]
                ],
                "line-opacity": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    8,
                    0,
                    8.5,
                    1
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "land-and-water",
                "mapbox:group": "Land & water, water"
            }
        },
        {
            "id": "water",
            "type": "fill",
            "source": "composite",
            "source-layer": "water",
            "layout": {},
            "paint": {
                "fill-color": "hsl(196, 80%, 70%)"
            },
            "metadata": {
                "mapbox:featureComponent": "land-and-water",
                "mapbox:group": "Land & water, water"
            }
        },
        {
            "id": "wetland",
            "type": "fill",
            "source": "composite",
            "source-layer": "landuse_overlay",
            "minzoom": 5,
            "filter": [
                "match",
                [
                    "get",
                    "class"
                ],
                [
                    "wetland",
                    "wetland_noveg"
                ],
                true,
                false
            ],
            "paint": {
                "fill-color": "hsl(185, 43%, 74%)",
                "fill-opacity": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    10,
                    0.25,
                    10.5,
                    0.15
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "land-and-water",
                "mapbox:group": "Land & water, water"
            }
        },
        {
            "id": "wetland-pattern",
            "type": "fill",
            "source": "composite",
            "source-layer": "landuse_overlay",
            "minzoom": 5,
            "filter": [
                "match",
                [
                    "get",
                    "class"
                ],
                [
                    "wetland",
                    "wetland_noveg"
                ],
                true,
                false
            ],
            "paint": {
                "fill-color": "hsl(185, 43%, 74%)",
                "fill-opacity": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    10,
                    0,
                    10.5,
                    1
                ],
                "fill-pattern": "wetland",
                "fill-translate-anchor": "viewport"
            },
            "metadata": {
                "mapbox:featureComponent": "land-and-water",
                "mapbox:group": "Land & water, water"
            }
        },
        {
            "id": "hillshade",
            "type": "fill",
            "source": "composite",
            "source-layer": "hillshade",
            "maxzoom": 16,
            "layout": {},
            "paint": {
                "fill-color": [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "shadow",
                    "hsl(65, 35%, 21%)",
                    "hsl(35, 11%, 100%)"
                ],
                "fill-opacity": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    14,
                    [
                        "match",
                        [
                            "get",
                            "level"
                        ],
                        [
                            67,
                            56
                        ],
                        0.06,
                        [
                            89,
                            78
                        ],
                        0.05,
                        0.12
                    ],
                    16,
                    0
                ],
                "fill-antialias": false
            },
            "metadata": {
                "mapbox:featureComponent": "terrain",
                "mapbox:group": "Terrain, land"
            }
        },
        {
            "minzoom": 11,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "terrain",
                "mapbox:group": "Terrain, land"
            },
            "filter": [
                "!=",
                [
                    "get",
                    "index"
                ],
                -1
            ],
            "type": "line",
            "source": "composite",
            "id": "contour-line",
            "paint": {
                "line-opacity": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    11,
                    [
                        "match",
                        [
                            "get",
                            "index"
                        ],
                        [
                            1,
                            2
                        ],
                        0.15,
                        0.25
                    ],
                    12,
                    [
                        "match",
                        [
                            "get",
                            "index"
                        ],
                        [
                            1,
                            2
                        ],
                        0.3,
                        0.5
                    ]
                ],
                "line-color": "hsl(100, 99%, 19%)",
                "line-width": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    13,
                    [
                        "match",
                        [
                            "get",
                            "index"
                        ],
                        [
                            1,
                            2
                        ],
                        0.5,
                        0.6
                    ],
                    16,
                    [
                        "match",
                        [
                            "get",
                            "index"
                        ],
                        [
                            1,
                            2
                        ],
                        0.8,
                        1.2
                    ]
                ],
                "line-offset": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    13,
                    [
                        "match",
                        [
                            "get",
                            "index"
                        ],
                        [
                            1,
                            2
                        ],
                        1,
                        0.6
                    ],
                    16,
                    [
                        "match",
                        [
                            "get",
                            "index"
                        ],
                        [
                            1,
                            2
                        ],
                        1.6,
                        1.2
                    ]
                ]
            },
            "source-layer": "contour"
        },
        {
            "minzoom": 13,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "land-and-water",
                "mapbox:group": "Land & water, built"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "Polygon"
                ],
                [
                    "==",
                    [
                        "get",
                        "class"
                    ],
                    "land"
                ]
            ],
            "type": "fill",
            "source": "composite",
            "id": "land-structure-polygon",
            "paint": {
                "fill-color": "hsl(35, 9%, 91%)"
            },
            "source-layer": "structure"
        },
        {
            "minzoom": 13,
            "layout": {
                "line-cap": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "land-and-water",
                "mapbox:group": "Land & water, built"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ],
                [
                    "==",
                    [
                        "get",
                        "class"
                    ],
                    "land"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "land-structure-line",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.99
                    ],
                    [
                        "zoom"
                    ],
                    14,
                    0.75,
                    20,
                    40
                ],
                "line-color": "hsl(35, 9%, 91%)"
            },
            "source-layer": "structure"
        },
        {
            "minzoom": 11,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "transit",
                "mapbox:group": "Transit, built"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "Polygon"
                ],
                [
                    "match",
                    [
                        "get",
                        "type"
                    ],
                    [
                        "runway",
                        "taxiway",
                        "helipad"
                    ],
                    true,
                    false
                ]
            ],
            "type": "fill",
            "source": "composite",
            "id": "aeroway-polygon",
            "paint": {
                "fill-color": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    "hsl(230, 20%, 83%)",
                    16,
                    "hsl(230, 36%, 85%)"
                ],
                "fill-opacity": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    11,
                    0,
                    11.5,
                    1
                ]
            },
            "source-layer": "aeroway"
        },
        {
            "minzoom": 9,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "transit",
                "mapbox:group": "Transit, built"
            },
            "filter": [
                "==",
                [
                    "geometry-type"
                ],
                "LineString"
            ],
            "type": "line",
            "source": "composite",
            "id": "aeroway-line",
            "paint": {
                "line-color": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    "hsl(230, 20%, 83%)",
                    16,
                    "hsl(230, 36%, 85%)"
                ],
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    9,
                    [
                        "match",
                        [
                            "get",
                            "type"
                        ],
                        "runway",
                        1,
                        0.5
                    ],
                    18,
                    [
                        "match",
                        [
                            "get",
                            "type"
                        ],
                        "runway",
                        80,
                        20
                    ]
                ]
            },
            "source-layer": "aeroway"
        },
        {
            "minzoom": 15,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "buildings",
                "mapbox:group": "Buildings, built"
            },
            "filter": [
                "all",
                [
                    "!=",
                    [
                        "get",
                        "type"
                    ],
                    "building:part"
                ],
                [
                    "==",
                    [
                        "get",
                        "underground"
                    ],
                    "false"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "building-outline",
            "paint": {
                "line-color": "hsl(35, 5%, 81%)",
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    0.75,
                    20,
                    3
                ],
                "line-opacity": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    0,
                    16,
                    1
                ]
            },
            "source-layer": "building"
        },
        {
            "minzoom": 15,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "buildings",
                "mapbox:group": "Buildings, built"
            },
            "filter": [
                "all",
                [
                    "!=",
                    [
                        "get",
                        "type"
                    ],
                    "building:part"
                ],
                [
                    "==",
                    [
                        "get",
                        "underground"
                    ],
                    "false"
                ]
            ],
            "type": "fill",
            "source": "composite",
            "id": "building",
            "paint": {
                "fill-color": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    "hsl(35, 8%, 87%)",
                    16,
                    "hsl(35, 4%, 87%)"
                ],
                "fill-opacity": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    0,
                    16,
                    1
                ],
                "fill-outline-color": "hsl(35, 5%, 81%)"
            },
            "source-layer": "building"
        },
        {
            "minzoom": 15,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "buildings",
                "mapbox:group": "Buildings, built"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "underground"
                    ],
                    "true"
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "Polygon"
                ]
            ],
            "type": "fill",
            "source": "composite",
            "id": "building-underground",
            "paint": {
                "fill-color": "hsl(260, 67%, 80%)",
                "fill-opacity": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    0,
                    16,
                    0.5
                ]
            },
            "source-layer": "building"
        },
        {
            "minzoom": 13,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, tunnels-case"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "tunnel"
                ],
                [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "street",
                            "street_limited",
                            "primary_link",
                            "track"
                        ],
                        true,
                        false
                    ],
                    14,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "street",
                            "street_limited",
                            "track",
                            "primary_link",
                            "secondary_link",
                            "tertiary_link",
                            "service"
                        ],
                        true,
                        false
                    ]
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "tunnel-street-minor-low",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    12,
                    0.5,
                    14,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "street",
                            "street_limited",
                            "primary_link"
                        ],
                        2,
                        "track",
                        1,
                        0.5
                    ],
                    18,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "street",
                            "street_limited",
                            "primary_link"
                        ],
                        18,
                        12
                    ]
                ],
                "line-color": "hsl(0, 0%, 100%)",
                "line-opacity": [
                    "step",
                    [
                        "zoom"
                    ],
                    1,
                    14,
                    0
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, tunnels-case"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "tunnel"
                ],
                [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "street",
                            "street_limited",
                            "primary_link",
                            "track"
                        ],
                        true,
                        false
                    ],
                    14,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "street",
                            "street_limited",
                            "track",
                            "primary_link",
                            "secondary_link",
                            "tertiary_link",
                            "service"
                        ],
                        true,
                        false
                    ]
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "tunnel-street-minor-case",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    12,
                    0.75,
                    20,
                    2
                ],
                "line-color": "hsl(230, 19%, 75%)",
                "line-gap-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    12,
                    0.5,
                    14,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "street",
                            "street_limited",
                            "primary_link"
                        ],
                        2,
                        "track",
                        1,
                        0.5
                    ],
                    18,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "street",
                            "street_limited",
                            "primary_link"
                        ],
                        18,
                        12
                    ]
                ],
                "line-opacity": [
                    "step",
                    [
                        "zoom"
                    ],
                    0,
                    14,
                    1
                ],
                "line-dasharray": [
                    3,
                    3
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, tunnels-case"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "tunnel"
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "primary",
                        "secondary",
                        "tertiary"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "tunnel-primary-secondary-tertiary-case",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    10,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        "primary",
                        1,
                        0.75
                    ],
                    18,
                    2
                ],
                "line-color": "hsl(230, 19%, 75%)",
                "line-gap-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    5,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        "primary",
                        0.75,
                        0.1
                    ],
                    18,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        "primary",
                        32,
                        26
                    ]
                ],
                "line-dasharray": [
                    3,
                    3
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, tunnels-case"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "tunnel"
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "motorway_link",
                        "trunk_link"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "tunnel-major-link-case",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    12,
                    0.75,
                    20,
                    2
                ],
                "line-color": "hsl(0, 0%, 100%)",
                "line-gap-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    12,
                    0.5,
                    14,
                    2,
                    18,
                    18
                ],
                "line-dasharray": [
                    3,
                    3
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, tunnels-case"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "tunnel"
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "motorway",
                        "trunk"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "tunnel-motorway-trunk-case",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    10,
                    1,
                    18,
                    2
                ],
                "line-color": "hsl(230, 26%, 100%)",
                "line-gap-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    5,
                    0.75,
                    18,
                    32
                ],
                "line-dasharray": [
                    3,
                    3
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 14,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, tunnels-case"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "tunnel"
                ],
                [
                    "==",
                    [
                        "get",
                        "class"
                    ],
                    "construction"
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "tunnel-construction",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    14,
                    2,
                    18,
                    18
                ],
                "line-color": "hsl(230, 26%, 88%)",
                "line-dasharray": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "literal",
                        [
                            0.4,
                            0.8
                        ]
                    ],
                    15,
                    [
                        "literal",
                        [
                            0.3,
                            0.6
                        ]
                    ],
                    16,
                    [
                        "literal",
                        [
                            0.2,
                            0.3
                        ]
                    ],
                    17,
                    [
                        "literal",
                        [
                            0.2,
                            0.25
                        ]
                    ],
                    18,
                    [
                        "literal",
                        [
                            0.15,
                            0.15
                        ]
                    ]
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 14,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., tunnels"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "tunnel"
                ],
                [
                    "==",
                    [
                        "get",
                        "class"
                    ],
                    "path"
                ],
                [
                    "match",
                    [
                        "get",
                        "type"
                    ],
                    [
                        "hiking",
                        "mountain_bike",
                        "trail"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "tunnel-path-trail",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    1,
                    18,
                    4
                ],
                "line-color": "hsl(35, 23%, 95%)",
                "line-dasharray": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "literal",
                        [
                            4,
                            0.3
                        ]
                    ],
                    15,
                    [
                        "literal",
                        [
                            1.75,
                            0.3
                        ]
                    ],
                    16,
                    [
                        "literal",
                        [
                            1,
                            0.3
                        ]
                    ],
                    17,
                    [
                        "literal",
                        [
                            1,
                            0.25
                        ]
                    ]
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 12,
            "layout": {
                "line-cap": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., tunnels"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "tunnel"
                ],
                [
                    "==",
                    [
                        "get",
                        "class"
                    ],
                    "path"
                ],
                [
                    "match",
                    [
                        "get",
                        "type"
                    ],
                    [
                        "cycleway",
                        "piste"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "tunnel-path-cycleway-piste",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    1,
                    18,
                    4
                ],
                "line-color": "hsl(35, 23%, 95%)",
                "line-dasharray": [
                    10,
                    0
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 14,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., tunnels"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "tunnel"
                ],
                [
                    "==",
                    [
                        "get",
                        "class"
                    ],
                    "path"
                ],
                [
                    "all",
                    [
                        "match",
                        [
                            "get",
                            "type"
                        ],
                        [
                            "hiking",
                            "mountain_bike",
                            "trail",
                            "cycleway",
                            "piste"
                        ],
                        false,
                        true
                    ],
                    [
                        "!=",
                        [
                            "get",
                            "type"
                        ],
                        "steps"
                    ]
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "tunnel-path",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    1,
                    18,
                    4
                ],
                "line-color": "hsl(35, 23%, 95%)",
                "line-dasharray": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "literal",
                        [
                            5,
                            0.5
                        ]
                    ],
                    15,
                    [
                        "literal",
                        [
                            4,
                            0.5
                        ]
                    ],
                    16,
                    [
                        "literal",
                        [
                            4,
                            0.45
                        ]
                    ]
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 14,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., tunnels"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "tunnel"
                ],
                [
                    "==",
                    [
                        "get",
                        "type"
                    ],
                    "steps"
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "tunnel-steps",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    1,
                    16,
                    1.6,
                    18,
                    6
                ],
                "line-color": "hsl(35, 23%, 95%)",
                "line-dasharray": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "literal",
                        [
                            1,
                            0
                        ]
                    ],
                    15,
                    [
                        "literal",
                        [
                            1.75,
                            1
                        ]
                    ],
                    16,
                    [
                        "literal",
                        [
                            1,
                            0.75
                        ]
                    ],
                    17,
                    [
                        "literal",
                        [
                            0.3,
                            0.3
                        ]
                    ]
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., tunnels"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "tunnel"
                ],
                [
                    "==",
                    [
                        "get",
                        "class"
                    ],
                    "pedestrian"
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "tunnel-pedestrian",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    14,
                    0.5,
                    18,
                    12
                ],
                "line-color": "hsl(0, 0%, 100%)",
                "line-dasharray": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "literal",
                        [
                            1,
                            0
                        ]
                    ],
                    15,
                    [
                        "literal",
                        [
                            1.5,
                            0.4
                        ]
                    ],
                    16,
                    [
                        "literal",
                        [
                            1,
                            0.2
                        ]
                    ]
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, tunnels"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "tunnel"
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "motorway_link",
                        "trunk_link"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "tunnel-major-link",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    12,
                    0.5,
                    14,
                    2,
                    18,
                    18
                ],
                "line-color": [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "motorway_link",
                    "hsl(26, 74%, 78%)",
                    "hsl(46, 64%, 78%)"
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, tunnels"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "tunnel"
                ],
                [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "street",
                            "street_limited",
                            "primary_link",
                            "track"
                        ],
                        true,
                        false
                    ],
                    14,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "street",
                            "street_limited",
                            "track",
                            "primary_link",
                            "secondary_link",
                            "tertiary_link",
                            "service"
                        ],
                        true,
                        false
                    ]
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "tunnel-street-minor",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    12,
                    0.5,
                    14,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "street",
                            "street_limited",
                            "primary_link"
                        ],
                        2,
                        "track",
                        1,
                        0.5
                    ],
                    18,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "street",
                            "street_limited",
                            "primary_link"
                        ],
                        18,
                        12
                    ]
                ],
                "line-color": [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "street_limited",
                    "hsl(35, 13%, 94%)",
                    "hsl(0, 0%, 100%)"
                ],
                "line-opacity": [
                    "step",
                    [
                        "zoom"
                    ],
                    0,
                    14,
                    1
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, tunnels"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "tunnel"
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "primary",
                        "secondary",
                        "tertiary"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "tunnel-primary-secondary-tertiary",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    5,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        "primary",
                        0.75,
                        0.1
                    ],
                    18,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        "primary",
                        32,
                        26
                    ]
                ],
                "line-color": "hsl(0, 0%, 100%)"
            },
            "source-layer": "road"
        },
        {
            "minzoom": 15,
            "layout": {
                "symbol-placement": "line",
                "icon-image": [
                    "step",
                    [
                        "zoom"
                    ],
                    "oneway-small",
                    17,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "primary",
                            "secondary",
                            "tertiary",
                            "street",
                            "street_limited"
                        ],
                        "oneway-large",
                        "oneway-small"
                    ],
                    18,
                    "oneway-large"
                ],
                "symbol-spacing": 200,
                "icon-rotation-alignment": "map"
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, tunnels"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "tunnel"
                ],
                [
                    "==",
                    [
                        "get",
                        "oneway"
                    ],
                    "true"
                ],
                [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "primary",
                            "secondary",
                            "street",
                            "street_limited",
                            "tertiary"
                        ],
                        true,
                        false
                    ],
                    16,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "primary",
                            "secondary",
                            "tertiary",
                            "street",
                            "street_limited",
                            "primary_link",
                            "secondary_link",
                            "tertiary_link",
                            "service",
                            "track"
                        ],
                        true,
                        false
                    ]
                ]
            ],
            "type": "symbol",
            "source": "composite",
            "id": "tunnel-oneway-arrow-blue",
            "paint": {},
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, tunnels"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "tunnel"
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "motorway",
                        "trunk"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "tunnel-motorway-trunk",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    5,
                    0.75,
                    18,
                    32
                ],
                "line-color": [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "motorway",
                    "hsl(26, 74%, 78%)",
                    "hsl(46, 64%, 78%)"
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 16,
            "layout": {
                "symbol-placement": "line",
                "icon-image": [
                    "step",
                    [
                        "zoom"
                    ],
                    "oneway-white-small",
                    17,
                    "oneway-white-large"
                ],
                "symbol-spacing": 200
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, tunnels"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "tunnel"
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "motorway",
                        "motorway_link",
                        "trunk",
                        "trunk_link"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "get",
                        "oneway"
                    ],
                    "true"
                ]
            ],
            "type": "symbol",
            "source": "composite",
            "id": "tunnel-oneway-arrow-white",
            "paint": {},
            "source-layer": "road"
        },
        {
            "minzoom": 15,
            "layout": {
                "line-cap": "round",
                "line-join": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "terrain",
                "mapbox:group": "Terrain, surface"
            },
            "filter": [
                "==",
                [
                    "get",
                    "class"
                ],
                "cliff"
            ],
            "type": "line",
            "source": "composite",
            "id": "cliff",
            "paint": {
                "line-opacity": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    0,
                    15.25,
                    1
                ],
                "line-width": 10,
                "line-pattern": "cliff"
            },
            "source-layer": "structure"
        },
        {
            "minzoom": 8,
            "layout": {
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "transit",
                "mapbox:group": "Transit, ferries"
            },
            "filter": [
                "==",
                [
                    "get",
                    "type"
                ],
                "ferry"
            ],
            "type": "line",
            "source": "composite",
            "id": "ferry",
            "paint": {
                "line-color": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    "hsl(205, 73%, 63%)",
                    17,
                    "hsl(230, 73%, 63%)"
                ],
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    14,
                    0.5,
                    20,
                    1
                ],
                "line-dasharray": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "literal",
                        [
                            1,
                            0
                        ]
                    ],
                    13,
                    [
                        "literal",
                        [
                            12,
                            4
                        ]
                    ]
                ]
            },
            "source-layer": "road"
        },
        {
            "id": "ferry-auto",
            "type": "line",
            "source": "composite",
            "source-layer": "road",
            "filter": [
                "==",
                [
                    "get",
                    "type"
                ],
                "ferry_auto"
            ],
            "layout": {
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "paint": {
                "line-color": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    "hsl(205, 73%, 63%)",
                    17,
                    "hsl(230, 73%, 63%)"
                ],
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    14,
                    0.5,
                    20,
                    1
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "transit",
                "mapbox:group": "Transit, ferries"
            }
        },
        {
            "minzoom": 12,
            "layout": {
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., surface"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "class"
                    ],
                    "path"
                ],
                [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "!",
                        [
                            "match",
                            [
                                "get",
                                "type"
                            ],
                            [
                                "steps",
                                "sidewalk",
                                "crossing"
                            ],
                            true,
                            false
                        ]
                    ],
                    16,
                    [
                        "!=",
                        [
                            "get",
                            "type"
                        ],
                        "steps"
                    ]
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "road-path-bg",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    2,
                    18,
                    7
                ],
                "line-color": [
                    "match",
                    [
                        "get",
                        "type"
                    ],
                    "piste",
                    "hsl(230, 100%, 60%)",
                    [
                        "mountain_bike",
                        "hiking",
                        "trail",
                        "cycleway",
                        "footway",
                        "path",
                        "bridleway"
                    ],
                    "hsl(50, 100%, 40%)",
                    "hsl(230, 17%, 82%)"
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 14,
            "layout": {
                "line-join": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., surface"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "type"
                    ],
                    "steps"
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "road-steps-bg",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    2,
                    17,
                    4.6,
                    18,
                    7
                ],
                "line-opacity": 0.75,
                "line-color": "hsl(50, 100%, 40%)"
            },
            "source-layer": "road"
        },
        {
            "minzoom": 14,
            "layout": {
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., surface"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "class"
                    ],
                    "pedestrian"
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "road-pedestrian-case",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    14,
                    2,
                    18,
                    14.5
                ],
                "line-color": "hsl(230, 26%, 88%)"
            },
            "source-layer": "road"
        },
        {
            "minzoom": 12,
            "layout": {
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., surface"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "class"
                    ],
                    "path"
                ],
                [
                    "match",
                    [
                        "get",
                        "type"
                    ],
                    [
                        "hiking",
                        "mountain_bike",
                        "trail"
                    ],
                    true,
                    false
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "road-path-trail",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    1,
                    18,
                    4
                ],
                "line-color": "hsl(0, 0%, 100%)",
                "line-dasharray": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "literal",
                        [
                            4,
                            0.3
                        ]
                    ],
                    15,
                    [
                        "literal",
                        [
                            1.75,
                            0.3
                        ]
                    ],
                    16,
                    [
                        "literal",
                        [
                            1,
                            0.3
                        ]
                    ],
                    17,
                    [
                        "literal",
                        [
                            1,
                            0.25
                        ]
                    ]
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 12,
            "layout": {
                "line-cap": "round",
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., surface"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "class"
                    ],
                    "path"
                ],
                [
                    "match",
                    [
                        "get",
                        "type"
                    ],
                    [
                        "cycleway",
                        "piste"
                    ],
                    true,
                    false
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "road-path-cycleway-piste",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    1,
                    18,
                    4
                ],
                "line-color": "hsl(0, 0%, 100%)",
                "line-dasharray": [
                    10,
                    0
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 12,
            "layout": {
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., surface"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "class"
                    ],
                    "path"
                ],
                [
                    "all",
                    [
                        "match",
                        [
                            "get",
                            "type"
                        ],
                        [
                            "hiking",
                            "mountain_bike",
                            "trail",
                            "cycleway",
                            "piste"
                        ],
                        false,
                        true
                    ],
                    [
                        "step",
                        [
                            "zoom"
                        ],
                        [
                            "!",
                            [
                                "match",
                                [
                                    "get",
                                    "type"
                                ],
                                [
                                    "steps",
                                    "sidewalk",
                                    "crossing"
                                ],
                                true,
                                false
                            ]
                        ],
                        16,
                        [
                            "!=",
                            [
                                "get",
                                "type"
                            ],
                            "steps"
                        ]
                    ]
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "road-path",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    13,
                    0.5,
                    14,
                    1,
                    15,
                    1,
                    18,
                    4
                ],
                "line-color": "hsl(0, 0%, 100%)",
                "line-dasharray": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "literal",
                        [
                            5,
                            0.5
                        ]
                    ],
                    15,
                    [
                        "literal",
                        [
                            4,
                            0.5
                        ]
                    ],
                    16,
                    [
                        "literal",
                        [
                            4,
                            0.45
                        ]
                    ]
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 14,
            "layout": {
                "line-join": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., surface"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "type"
                    ],
                    "steps"
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "road-steps",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    1,
                    16,
                    1.6,
                    18,
                    6
                ],
                "line-color": "hsl(0, 0%, 100%)",
                "line-dasharray": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "literal",
                        [
                            1,
                            0
                        ]
                    ],
                    15,
                    [
                        "literal",
                        [
                            1.75,
                            1
                        ]
                    ],
                    16,
                    [
                        "literal",
                        [
                            1,
                            0.75
                        ]
                    ],
                    17,
                    [
                        "literal",
                        [
                            0.3,
                            0.3
                        ]
                    ]
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 12,
            "layout": {
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., surface"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "class"
                    ],
                    "pedestrian"
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "road-pedestrian",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    14,
                    0.5,
                    18,
                    12
                ],
                "line-color": "hsl(0, 0%, 100%)",
                "line-dasharray": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "literal",
                        [
                            1,
                            0
                        ]
                    ],
                    15,
                    [
                        "literal",
                        [
                            1.5,
                            0.4
                        ]
                    ],
                    16,
                    [
                        "literal",
                        [
                            1,
                            0.2
                        ]
                    ]
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 12,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., surface"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "Polygon"
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "path",
                        "pedestrian"
                    ],
                    true,
                    false
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ],
                [
                    "case",
                    [
                        "has",
                        "layer"
                    ],
                    [
                        ">=",
                        [
                            "get",
                            "layer"
                        ],
                        0
                    ],
                    true
                ]
            ],
            "type": "fill",
            "source": "composite",
            "id": "road-pedestrian-polygon-fill",
            "paint": {
                "fill-color": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    16,
                    "hsl(230, 16%, 94%)",
                    16.25,
                    "hsl(230, 52%, 98%)"
                ],
                "fill-outline-color": "hsl(230, 26%, 88%)"
            },
            "source-layer": "road"
        },
        {
            "minzoom": 16,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., surface"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "Polygon"
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "path",
                        "pedestrian"
                    ],
                    true,
                    false
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ],
                [
                    "case",
                    [
                        "has",
                        "layer"
                    ],
                    [
                        ">=",
                        [
                            "get",
                            "layer"
                        ],
                        0
                    ],
                    true
                ]
            ],
            "type": "fill",
            "source": "composite",
            "id": "road-pedestrian-polygon-pattern",
            "paint": {
                "fill-pattern": "pedestrian-polygon",
                "fill-opacity": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    16,
                    0,
                    16.25,
                    1
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 16,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., surface"
            },
            "filter": [
                "==",
                [
                    "get",
                    "class"
                ],
                "golf"
            ],
            "type": "line",
            "source": "composite",
            "id": "golf-hole-line",
            "paint": {
                "line-color": "hsl(99, 27%, 70%)"
            },
            "source-layer": "road"
        },
        {
            "minzoom": 15,
            "layout": {
                "icon-image": "turning-circle-outline",
                "icon-size": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    14,
                    0.122,
                    18,
                    0.969,
                    20,
                    1
                ],
                "icon-allow-overlap": true,
                "icon-ignore-placement": true,
                "icon-padding": 0,
                "icon-rotation-alignment": "map"
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, surface"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "Point"
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "turning_circle",
                        "turning_loop"
                    ],
                    true,
                    false
                ]
            ],
            "type": "symbol",
            "source": "composite",
            "id": "turning-feature-outline",
            "paint": {},
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {
                "line-cap": [
                    "step",
                    [
                        "zoom"
                    ],
                    "butt",
                    14,
                    "round"
                ],
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, surface"
            },
            "filter": [
                "all",
                [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "==",
                        [
                            "get",
                            "class"
                        ],
                        "track"
                    ],
                    14,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "track",
                            "secondary_link",
                            "tertiary_link",
                            "service"
                        ],
                        true,
                        false
                    ]
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "road-minor-low",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    14,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        "track",
                        1,
                        0.5
                    ],
                    18,
                    12
                ],
                "line-color": "hsl(0, 0%, 100%)",
                "line-opacity": [
                    "step",
                    [
                        "zoom"
                    ],
                    1,
                    14,
                    0
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {
                "line-cap": [
                    "step",
                    [
                        "zoom"
                    ],
                    "butt",
                    14,
                    "round"
                ],
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, surface"
            },
            "filter": [
                "all",
                [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "==",
                        [
                            "get",
                            "class"
                        ],
                        "track"
                    ],
                    14,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "track",
                            "secondary_link",
                            "tertiary_link",
                            "service"
                        ],
                        true,
                        false
                    ]
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "road-minor-case",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    12,
                    0.75,
                    20,
                    2
                ],
                "line-color": [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "track",
                    "hsl(50, 100%, 40%)",
                    "hsl(230, 26%, 88%)"
                ],
                "line-gap-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    14,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        "track",
                        1,
                        0.5
                    ],
                    18,
                    12
                ],
                "line-opacity": [
                    "step",
                    [
                        "zoom"
                    ],
                    0,
                    14,
                    1
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 11,
            "layout": {
                "line-cap": [
                    "step",
                    [
                        "zoom"
                    ],
                    "butt",
                    14,
                    "round"
                ],
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, surface"
            },
            "filter": [
                "all",
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "street",
                        "street_limited",
                        "primary_link"
                    ],
                    true,
                    false
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "road-street-low",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    12,
                    0.5,
                    14,
                    2,
                    18,
                    18
                ],
                "line-color": "hsl(0, 0%, 100%)",
                "line-opacity": [
                    "step",
                    [
                        "zoom"
                    ],
                    1,
                    14,
                    0
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 11,
            "layout": {
                "line-cap": [
                    "step",
                    [
                        "zoom"
                    ],
                    "butt",
                    14,
                    "round"
                ],
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, surface"
            },
            "filter": [
                "all",
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "street",
                        "street_limited",
                        "primary_link"
                    ],
                    true,
                    false
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "road-street-case",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    12,
                    0.75,
                    20,
                    2
                ],
                "line-color": "hsl(230, 26%, 88%)",
                "line-gap-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    12,
                    0.5,
                    14,
                    2,
                    18,
                    18
                ],
                "line-opacity": [
                    "step",
                    [
                        "zoom"
                    ],
                    0,
                    14,
                    1
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 8,
            "layout": {
                "line-cap": [
                    "step",
                    [
                        "zoom"
                    ],
                    "butt",
                    14,
                    "round"
                ],
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, surface"
            },
            "filter": [
                "all",
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "secondary",
                        "tertiary"
                    ],
                    true,
                    false
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "road-secondary-tertiary-case",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    10,
                    0.75,
                    18,
                    2
                ],
                "line-color": "hsl(230, 26%, 88%)",
                "line-gap-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    5,
                    0.1,
                    18,
                    26
                ],
                "line-opacity": [
                    "step",
                    [
                        "zoom"
                    ],
                    0,
                    10,
                    1
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 7,
            "layout": {
                "line-cap": [
                    "step",
                    [
                        "zoom"
                    ],
                    "butt",
                    14,
                    "round"
                ],
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, surface"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "class"
                    ],
                    "primary"
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "road-primary-case",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    10,
                    1,
                    18,
                    2
                ],
                "line-color": "hsl(230, 26%, 88%)",
                "line-gap-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    5,
                    0.75,
                    18,
                    32
                ],
                "line-opacity": [
                    "step",
                    [
                        "zoom"
                    ],
                    0,
                    10,
                    1
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 10,
            "layout": {
                "line-cap": [
                    "step",
                    [
                        "zoom"
                    ],
                    "butt",
                    14,
                    "round"
                ],
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, surface"
            },
            "filter": [
                "all",
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "motorway_link",
                        "trunk_link"
                    ],
                    true,
                    false
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "road-major-link-case",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    12,
                    0.75,
                    20,
                    2
                ],
                "line-color": "hsl(230, 26%, 100%)",
                "line-gap-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    12,
                    0.5,
                    14,
                    2,
                    18,
                    18
                ],
                "line-opacity": [
                    "step",
                    [
                        "zoom"
                    ],
                    0,
                    11,
                    1
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 5,
            "layout": {
                "line-cap": [
                    "step",
                    [
                        "zoom"
                    ],
                    "butt",
                    14,
                    "round"
                ],
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, surface"
            },
            "filter": [
                "all",
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "motorway",
                        "trunk"
                    ],
                    true,
                    false
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "road-motorway-trunk-case",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    10,
                    1,
                    18,
                    2
                ],
                "line-color": "hsl(230, 26%, 100%)",
                "line-gap-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    5,
                    0.75,
                    18,
                    32
                ],
                "line-opacity": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        "motorway",
                        1,
                        0
                    ],
                    6,
                    1
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 14,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, surface"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "class"
                    ],
                    "construction"
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "road-construction",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    14,
                    2,
                    18,
                    18
                ],
                "line-color": "hsl(0, 0%, 100%)",
                "line-dasharray": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "literal",
                        [
                            0.4,
                            0.8
                        ]
                    ],
                    15,
                    [
                        "literal",
                        [
                            0.3,
                            0.6
                        ]
                    ],
                    16,
                    [
                        "literal",
                        [
                            0.2,
                            0.3
                        ]
                    ],
                    17,
                    [
                        "literal",
                        [
                            0.2,
                            0.25
                        ]
                    ],
                    18,
                    [
                        "literal",
                        [
                            0.15,
                            0.15
                        ]
                    ]
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 10,
            "layout": {
                "line-cap": [
                    "step",
                    [
                        "zoom"
                    ],
                    "butt",
                    13,
                    "round"
                ],
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    13,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, surface"
            },
            "filter": [
                "all",
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "motorway_link",
                        "trunk_link"
                    ],
                    true,
                    false
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "road-major-link",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    12,
                    0.5,
                    14,
                    2,
                    18,
                    18
                ],
                "line-color": [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "motorway_link",
                    "hsl(26, 67%, 68%)",
                    "hsl(46, 69%, 68%)"
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 12,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, surface"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "Polygon"
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "primary",
                        "secondary",
                        "tertiary",
                        "primary_link",
                        "secondary_link",
                        "tertiary_link",
                        "trunk",
                        "trunk_link",
                        "street",
                        "street_limited",
                        "track",
                        "service"
                    ],
                    true,
                    false
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ]
            ],
            "type": "fill",
            "source": "composite",
            "id": "road-polygon",
            "paint": {
                "fill-color": "hsl(0, 0%, 100%)",
                "fill-outline-color": "hsl(230, 26%, 88%)"
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {
                "line-cap": [
                    "step",
                    [
                        "zoom"
                    ],
                    "butt",
                    14,
                    "round"
                ],
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, surface"
            },
            "filter": [
                "all",
                [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "==",
                        [
                            "get",
                            "class"
                        ],
                        "track"
                    ],
                    14,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "track",
                            "secondary_link",
                            "tertiary_link",
                            "service"
                        ],
                        true,
                        false
                    ]
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "road-minor",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    14,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        "track",
                        1,
                        0.5
                    ],
                    18,
                    12
                ],
                "line-color": "hsl(0, 0%, 100%)",
                "line-opacity": [
                    "step",
                    [
                        "zoom"
                    ],
                    0,
                    14,
                    1
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 11,
            "layout": {
                "line-cap": [
                    "step",
                    [
                        "zoom"
                    ],
                    "butt",
                    14,
                    "round"
                ],
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, surface"
            },
            "filter": [
                "all",
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "street",
                        "street_limited",
                        "primary_link"
                    ],
                    true,
                    false
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "road-street",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    12,
                    0.5,
                    14,
                    2,
                    18,
                    18
                ],
                "line-color": [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "street_limited",
                    "hsl(35, 13%, 94%)",
                    "hsl(0, 0%, 100%)"
                ],
                "line-opacity": [
                    "step",
                    [
                        "zoom"
                    ],
                    0,
                    14,
                    1
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 8,
            "layout": {
                "line-cap": [
                    "step",
                    [
                        "zoom"
                    ],
                    "butt",
                    14,
                    "round"
                ],
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, surface"
            },
            "filter": [
                "all",
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "secondary",
                        "tertiary"
                    ],
                    true,
                    false
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "road-secondary-tertiary",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    5,
                    0.1,
                    18,
                    26
                ],
                "line-color": "hsl(0, 0%, 100%)"
            },
            "source-layer": "road"
        },
        {
            "minzoom": 6,
            "layout": {
                "line-cap": [
                    "step",
                    [
                        "zoom"
                    ],
                    "butt",
                    14,
                    "round"
                ],
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, surface"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "class"
                    ],
                    "primary"
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "road-primary",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    5,
                    0.75,
                    18,
                    32
                ],
                "line-color": "hsl(0, 0%, 100%)"
            },
            "source-layer": "road"
        },
        {
            "minzoom": 15,
            "layout": {
                "symbol-placement": "line",
                "icon-image": [
                    "step",
                    [
                        "zoom"
                    ],
                    "oneway-small",
                    17,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "primary",
                            "secondary",
                            "tertiary",
                            "street",
                            "street_limited"
                        ],
                        "oneway-large",
                        "oneway-small"
                    ],
                    18,
                    "oneway-large"
                ],
                "symbol-spacing": 200,
                "icon-rotation-alignment": "map"
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, surface"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "oneway"
                    ],
                    "true"
                ],
                [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "primary",
                            "secondary",
                            "tertiary",
                            "street",
                            "street_limited"
                        ],
                        true,
                        false
                    ],
                    16,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "primary",
                            "secondary",
                            "tertiary",
                            "street",
                            "street_limited",
                            "primary_link",
                            "secondary_link",
                            "tertiary_link",
                            "service",
                            "track"
                        ],
                        true,
                        false
                    ]
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ]
            ],
            "type": "symbol",
            "source": "composite",
            "id": "road-oneway-arrow-blue",
            "paint": {},
            "source-layer": "road"
        },
        {
            "id": "road-motorway-trunk",
            "type": "line",
            "source": "composite",
            "source-layer": "road",
            "filter": [
                "all",
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "motorway",
                        "trunk"
                    ],
                    true,
                    false
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "layout": {
                "line-cap": [
                    "step",
                    [
                        "zoom"
                    ],
                    "butt",
                    13,
                    "round"
                ],
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    13,
                    "round"
                ]
            },
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    5,
                    0.75,
                    18,
                    32
                ],
                "line-color": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        "motorway",
                        "hsl(26, 74%, 62%)",
                        "hsl(0, 0%, 100%)"
                    ],
                    6,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        "motorway",
                        "hsl(26, 74%, 62%)",
                        "hsl(46, 67%, 60%)"
                    ],
                    9,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        "motorway",
                        "hsl(26, 67%, 68%)",
                        "hsl(46, 69%, 68%)"
                    ]
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, surface"
            }
        },
        {
            "minzoom": 13,
            "layout": {
                "line-join": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "transit",
                "mapbox:group": "Transit, surface"
            },
            "filter": [
                "all",
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "major_rail",
                        "minor_rail"
                    ],
                    true,
                    false
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "road-rail",
            "paint": {
                "line-color": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    13,
                    "hsl(50, 16%, 82%)",
                    16,
                    "hsl(230, 10%, 74%)"
                ],
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    14,
                    0.5,
                    20,
                    1
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {
                "line-join": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "transit",
                "mapbox:group": "Transit, surface"
            },
            "filter": [
                "all",
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "major_rail",
                        "minor_rail"
                    ],
                    true,
                    false
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "road-rail-tracks",
            "paint": {
                "line-color": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    13,
                    "hsl(50, 16%, 82%)",
                    16,
                    "hsl(230, 10%, 74%)"
                ],
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    14,
                    4,
                    20,
                    8
                ],
                "line-dasharray": [
                    0.1,
                    15
                ],
                "line-opacity": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    13.75,
                    0,
                    14,
                    1
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 16,
            "layout": {
                "icon-image": "level-crossing",
                "icon-allow-overlap": true
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, surface-icons"
            },
            "filter": [
                "==",
                [
                    "get",
                    "class"
                ],
                "level_crossing"
            ],
            "type": "symbol",
            "source": "composite",
            "id": "level-crossing",
            "paint": {},
            "source-layer": "road"
        },
        {
            "minzoom": 16,
            "layout": {
                "symbol-placement": "line",
                "icon-image": [
                    "step",
                    [
                        "zoom"
                    ],
                    "oneway-white-small",
                    17,
                    "oneway-white-large"
                ],
                "symbol-spacing": 200
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, surface-icons"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "oneway"
                    ],
                    "true"
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "motorway",
                        "trunk",
                        "motorway_link",
                        "trunk_link"
                    ],
                    true,
                    false
                ],
                [
                    "match",
                    [
                        "get",
                        "structure"
                    ],
                    [
                        "none",
                        "ford"
                    ],
                    true,
                    false
                ]
            ],
            "type": "symbol",
            "source": "composite",
            "id": "road-oneway-arrow-white",
            "paint": {},
            "source-layer": "road"
        },
        {
            "minzoom": 15,
            "layout": {
                "icon-image": "turning-circle",
                "icon-size": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    14,
                    0.095,
                    18,
                    1
                ],
                "icon-allow-overlap": true,
                "icon-ignore-placement": true,
                "icon-padding": 0,
                "icon-rotation-alignment": "map"
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, surface-icons"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "Point"
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "turning_circle",
                        "turning_loop"
                    ],
                    true,
                    false
                ]
            ],
            "type": "symbol",
            "source": "composite",
            "id": "turning-feature",
            "paint": {},
            "source-layer": "road"
        },
        {
            "minzoom": 16,
            "layout": {
                "line-cap": "round",
                "line-join": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., barriers-bridges"
            },
            "filter": [
                "match",
                [
                    "get",
                    "class"
                ],
                [
                    "gate",
                    "fence",
                    "hedge"
                ],
                true,
                false
            ],
            "type": "line",
            "source": "composite",
            "id": "gate-fence-hedge",
            "paint": {
                "line-color": [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "hedge",
                    "hsl(99, 34%, 70%)",
                    "hsl(35, 16%, 77%)"
                ],
                "line-width": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    16,
                    1,
                    20,
                    3
                ],
                "line-opacity": [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "gate",
                    0.5,
                    1
                ],
                "line-dasharray": [
                    1,
                    2,
                    5,
                    2,
                    1,
                    2
                ]
            },
            "source-layer": "structure"
        },
        {
            "minzoom": 14,
            "layout": {
                "line-cap": [
                    "step",
                    [
                        "zoom"
                    ],
                    "butt",
                    14,
                    "round"
                ],
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., barriers-bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    "==",
                    [
                        "get",
                        "class"
                    ],
                    "path"
                ],
                [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "!",
                        [
                            "match",
                            [
                                "get",
                                "type"
                            ],
                            [
                                "steps",
                                "sidewalk",
                                "crossing"
                            ],
                            true,
                            false
                        ]
                    ],
                    16,
                    [
                        "!=",
                        [
                            "get",
                            "type"
                        ],
                        "steps"
                    ]
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "bridge-path-bg",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    2,
                    18,
                    7
                ],
                "line-color": [
                    "match",
                    [
                        "get",
                        "type"
                    ],
                    "piste",
                    "hsl(230, 100%, 60%)",
                    [
                        "mountain_bike",
                        "hiking",
                        "trail",
                        "cycleway",
                        "footway",
                        "path",
                        "bridleway"
                    ],
                    "hsl(50, 100%, 40%)",
                    "hsl(230, 17%, 82%)"
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 14,
            "layout": {
                "line-join": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., barriers-bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "type"
                    ],
                    "steps"
                ],
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "bridge-steps-bg",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    2,
                    17,
                    4.6,
                    18,
                    7
                ],
                "line-opacity": 0.75,
                "line-color": "hsl(50, 100%, 40%)"
            },
            "source-layer": "road"
        },
        {
            "minzoom": 14,
            "layout": {
                "line-join": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., barriers-bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    "==",
                    [
                        "get",
                        "class"
                    ],
                    "pedestrian"
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "bridge-pedestrian-case",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    14,
                    2,
                    18,
                    14.5
                ],
                "line-color": "hsl(230, 26%, 88%)"
            },
            "source-layer": "road"
        },
        {
            "minzoom": 14,
            "layout": {
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., barriers-bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    "==",
                    [
                        "get",
                        "class"
                    ],
                    "path"
                ],
                [
                    "match",
                    [
                        "get",
                        "type"
                    ],
                    [
                        "hiking",
                        "mountain_bike",
                        "trail"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "bridge-path-trail",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    1,
                    18,
                    4
                ],
                "line-color": "hsl(0, 0%, 100%)",
                "line-dasharray": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "literal",
                        [
                            4,
                            0.3
                        ]
                    ],
                    15,
                    [
                        "literal",
                        [
                            1.75,
                            0.3
                        ]
                    ],
                    16,
                    [
                        "literal",
                        [
                            1,
                            0.3
                        ]
                    ],
                    17,
                    [
                        "literal",
                        [
                            1,
                            0.25
                        ]
                    ]
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 14,
            "layout": {
                "line-cap": "round",
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., barriers-bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    "==",
                    [
                        "get",
                        "class"
                    ],
                    "path"
                ],
                [
                    "match",
                    [
                        "get",
                        "type"
                    ],
                    [
                        "cycleway",
                        "piste"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "bridge-path-cycleway-piste",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    1,
                    18,
                    4
                ],
                "line-color": "hsl(0, 0%, 100%)",
                "line-dasharray": [
                    10,
                    0
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 14,
            "layout": {
                "line-join": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., barriers-bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    "==",
                    [
                        "get",
                        "class"
                    ],
                    "path"
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ],
                [
                    "all",
                    [
                        "match",
                        [
                            "get",
                            "type"
                        ],
                        [
                            "hiking",
                            "mountain_bike",
                            "trail",
                            "cycleway",
                            "piste"
                        ],
                        false,
                        true
                    ],
                    [
                        "!=",
                        [
                            "get",
                            "type"
                        ],
                        "steps"
                    ]
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "bridge-path",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    1,
                    18,
                    4
                ],
                "line-color": "hsl(0, 0%, 100%)",
                "line-dasharray": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "literal",
                        [
                            5,
                            0.5
                        ]
                    ],
                    15,
                    [
                        "literal",
                        [
                            4,
                            0.5
                        ]
                    ],
                    16,
                    [
                        "literal",
                        [
                            4,
                            0.45
                        ]
                    ]
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 14,
            "layout": {
                "line-join": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., barriers-bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "type"
                    ],
                    "steps"
                ],
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "bridge-steps",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    1,
                    16,
                    1.6,
                    18,
                    6
                ],
                "line-color": "hsl(0, 0%, 100%)",
                "line-dasharray": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "literal",
                        [
                            1,
                            0
                        ]
                    ],
                    15,
                    [
                        "literal",
                        [
                            1.75,
                            1
                        ]
                    ],
                    16,
                    [
                        "literal",
                        [
                            1,
                            0.75
                        ]
                    ],
                    17,
                    [
                        "literal",
                        [
                            0.3,
                            0.3
                        ]
                    ]
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {
                "line-join": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., barriers-bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    "==",
                    [
                        "get",
                        "class"
                    ],
                    "pedestrian"
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "bridge-pedestrian",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    14,
                    0.5,
                    18,
                    12
                ],
                "line-color": "hsl(0, 0%, 100%)",
                "line-dasharray": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "literal",
                        [
                            1,
                            0
                        ]
                    ],
                    15,
                    [
                        "literal",
                        [
                            1.5,
                            0.4
                        ]
                    ],
                    16,
                    [
                        "literal",
                        [
                            1,
                            0.2
                        ]
                    ]
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {
                "line-cap": [
                    "step",
                    [
                        "zoom"
                    ],
                    "butt",
                    14,
                    "round"
                ],
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "street",
                            "street_limited",
                            "primary_link",
                            "track"
                        ],
                        true,
                        false
                    ],
                    14,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "street",
                            "street_limited",
                            "track",
                            "primary_link",
                            "secondary_link",
                            "tertiary_link",
                            "service"
                        ],
                        true,
                        false
                    ]
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "bridge-street-minor-low",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    12,
                    0.5,
                    14,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "street",
                            "street_limited",
                            "primary_link"
                        ],
                        2,
                        "track",
                        1,
                        0.5
                    ],
                    18,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "street",
                            "street_limited",
                            "primary_link"
                        ],
                        18,
                        12
                    ]
                ],
                "line-color": "hsl(0, 0%, 100%)",
                "line-opacity": [
                    "step",
                    [
                        "zoom"
                    ],
                    1,
                    14,
                    0
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {
                "line-join": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "street",
                            "street_limited",
                            "primary_link",
                            "track"
                        ],
                        true,
                        false
                    ],
                    14,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "street",
                            "street_limited",
                            "track",
                            "primary_link",
                            "secondary_link",
                            "tertiary_link",
                            "service"
                        ],
                        true,
                        false
                    ]
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "bridge-street-minor-case",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    12,
                    0.75,
                    20,
                    2
                ],
                "line-color": [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "track",
                    "hsl(50, 100%, 40%)",
                    "hsl(230, 26%, 88%)"
                ],
                "line-gap-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    12,
                    0.5,
                    14,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "street",
                            "street_limited",
                            "primary_link"
                        ],
                        2,
                        "track",
                        1,
                        0.5
                    ],
                    18,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "street",
                            "street_limited",
                            "primary_link"
                        ],
                        18,
                        12
                    ]
                ],
                "line-opacity": [
                    "step",
                    [
                        "zoom"
                    ],
                    0,
                    14,
                    1
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {
                "line-join": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "primary",
                        "secondary",
                        "tertiary"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "bridge-primary-secondary-tertiary-case",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    10,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        "primary",
                        1,
                        0.75
                    ],
                    18,
                    2
                ],
                "line-color": "hsl(230, 26%, 88%)",
                "line-gap-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    5,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        "primary",
                        0.75,
                        0.1
                    ],
                    18,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        "primary",
                        32,
                        26
                    ]
                ],
                "line-opacity": [
                    "step",
                    [
                        "zoom"
                    ],
                    0,
                    10,
                    1
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {
                "line-join": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "motorway_link",
                        "trunk_link"
                    ],
                    true,
                    false
                ],
                [
                    "<=",
                    [
                        "get",
                        "layer"
                    ],
                    1
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "bridge-major-link-case",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    12,
                    0.75,
                    20,
                    2
                ],
                "line-color": "hsl(230, 26%, 100%)",
                "line-gap-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    12,
                    0.5,
                    14,
                    2,
                    18,
                    18
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {
                "line-join": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "motorway",
                        "trunk"
                    ],
                    true,
                    false
                ],
                [
                    "<=",
                    [
                        "get",
                        "layer"
                    ],
                    1
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "bridge-motorway-trunk-case",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    10,
                    1,
                    18,
                    2
                ],
                "line-color": "hsl(230, 26%, 100%)",
                "line-gap-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    5,
                    0.75,
                    18,
                    32
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 14,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    "==",
                    [
                        "get",
                        "class"
                    ],
                    "construction"
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "bridge-construction",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    14,
                    2,
                    18,
                    18
                ],
                "line-color": "hsl(230, 26%, 88%)",
                "line-dasharray": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "literal",
                        [
                            0.4,
                            0.8
                        ]
                    ],
                    15,
                    [
                        "literal",
                        [
                            0.3,
                            0.6
                        ]
                    ],
                    16,
                    [
                        "literal",
                        [
                            0.2,
                            0.3
                        ]
                    ],
                    17,
                    [
                        "literal",
                        [
                            0.2,
                            0.25
                        ]
                    ],
                    18,
                    [
                        "literal",
                        [
                            0.15,
                            0.15
                        ]
                    ]
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {
                "line-cap": "round",
                "line-join": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "motorway_link",
                        "trunk_link"
                    ],
                    true,
                    false
                ],
                [
                    "<=",
                    [
                        "get",
                        "layer"
                    ],
                    1
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "bridge-major-link",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    12,
                    0.5,
                    14,
                    2,
                    18,
                    18
                ],
                "line-color": [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "motorway_link",
                    "hsl(26, 67%, 68%)",
                    "hsl(46, 69%, 68%)"
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {
                "line-cap": [
                    "step",
                    [
                        "zoom"
                    ],
                    "butt",
                    14,
                    "round"
                ],
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "street",
                            "street_limited",
                            "primary_link",
                            "track"
                        ],
                        true,
                        false
                    ],
                    14,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "street",
                            "street_limited",
                            "track",
                            "primary_link",
                            "secondary_link",
                            "tertiary_link",
                            "service"
                        ],
                        true,
                        false
                    ]
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "bridge-street-minor",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    12,
                    0.5,
                    14,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "street",
                            "street_limited",
                            "primary_link"
                        ],
                        2,
                        "track",
                        1,
                        0.5
                    ],
                    18,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "street",
                            "street_limited",
                            "primary_link"
                        ],
                        18,
                        12
                    ]
                ],
                "line-color": [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "street_limited",
                    "hsl(35, 13%, 94%)",
                    "hsl(0, 0%, 100%)"
                ],
                "line-opacity": [
                    "step",
                    [
                        "zoom"
                    ],
                    0,
                    14,
                    1
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {
                "line-cap": [
                    "step",
                    [
                        "zoom"
                    ],
                    "butt",
                    14,
                    "round"
                ],
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "primary",
                        "secondary",
                        "tertiary"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "bridge-primary-secondary-tertiary",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    5,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        "primary",
                        0.75,
                        0.1
                    ],
                    18,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        "primary",
                        32,
                        26
                    ]
                ],
                "line-color": "hsl(0, 0%, 100%)"
            },
            "source-layer": "road"
        },
        {
            "minzoom": 15,
            "layout": {
                "symbol-placement": "line",
                "icon-image": [
                    "step",
                    [
                        "zoom"
                    ],
                    "oneway-small",
                    17,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "primary",
                            "secondary",
                            "tertiary",
                            "street",
                            "street_limited"
                        ],
                        "oneway-large",
                        "oneway-small"
                    ],
                    18,
                    "oneway-large"
                ],
                "symbol-spacing": 200,
                "icon-rotation-alignment": "map"
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    "==",
                    [
                        "get",
                        "oneway"
                    ],
                    "true"
                ],
                [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "primary",
                            "secondary",
                            "tertiary",
                            "street",
                            "street_limited"
                        ],
                        true,
                        false
                    ],
                    16,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "primary",
                            "secondary",
                            "tertiary",
                            "street",
                            "street_limited",
                            "primary_link",
                            "secondary_link",
                            "tertiary_link",
                            "service",
                            "track"
                        ],
                        true,
                        false
                    ]
                ]
            ],
            "type": "symbol",
            "source": "composite",
            "id": "bridge-oneway-arrow-blue",
            "paint": {},
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {
                "line-cap": "round",
                "line-join": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "motorway",
                        "trunk"
                    ],
                    true,
                    false
                ],
                [
                    "<=",
                    [
                        "get",
                        "layer"
                    ],
                    1
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "bridge-motorway-trunk",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    5,
                    0.75,
                    18,
                    32
                ],
                "line-color": [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "motorway",
                    "hsl(26, 67%, 68%)",
                    "hsl(46, 69%, 68%)"
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {
                "line-join": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    ">=",
                    [
                        "get",
                        "layer"
                    ],
                    2
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "motorway_link",
                        "trunk_link"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "bridge-major-link-2-case",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    12,
                    0.75,
                    20,
                    2
                ],
                "line-color": "hsl(230, 26%, 100%)",
                "line-gap-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    12,
                    0.5,
                    14,
                    2,
                    18,
                    18
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {
                "line-join": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    ">=",
                    [
                        "get",
                        "layer"
                    ],
                    2
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "motorway",
                        "trunk"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "bridge-motorway-trunk-2-case",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    10,
                    1,
                    18,
                    2
                ],
                "line-color": "hsl(230, 26%, 100%)",
                "line-gap-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    5,
                    0.75,
                    18,
                    32
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {
                "line-cap": "round",
                "line-join": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    ">=",
                    [
                        "get",
                        "layer"
                    ],
                    2
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "motorway_link",
                        "trunk_link"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "bridge-major-link-2",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    12,
                    0.5,
                    14,
                    2,
                    18,
                    18
                ],
                "line-color": [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "motorway_link",
                    "hsl(26, 67%, 68%)",
                    "hsl(46, 69%, 68%)"
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {
                "line-cap": [
                    "step",
                    [
                        "zoom"
                    ],
                    "butt",
                    14,
                    "round"
                ],
                "line-join": [
                    "step",
                    [
                        "zoom"
                    ],
                    "miter",
                    14,
                    "round"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    ">=",
                    [
                        "get",
                        "layer"
                    ],
                    2
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "motorway",
                        "trunk"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "bridge-motorway-trunk-2",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    5,
                    0.75,
                    18,
                    32
                ],
                "line-color": [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "motorway",
                    "hsl(26, 67%, 68%)",
                    "hsl(46, 69%, 68%)"
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 16,
            "layout": {
                "symbol-placement": "line",
                "icon-image": [
                    "step",
                    [
                        "zoom"
                    ],
                    "oneway-white-small",
                    17,
                    "oneway-white-large"
                ],
                "symbol-spacing": 200
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "motorway",
                        "trunk",
                        "motorway_link",
                        "trunk_link"
                    ],
                    true,
                    false
                ],
                [
                    "==",
                    [
                        "get",
                        "oneway"
                    ],
                    "true"
                ]
            ],
            "type": "symbol",
            "source": "composite",
            "id": "bridge-oneway-arrow-white",
            "paint": {},
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {
                "line-join": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "transit",
                "mapbox:group": "Transit, bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "major_rail",
                        "minor_rail"
                    ],
                    true,
                    false
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "bridge-rail",
            "paint": {
                "line-color": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    13,
                    "hsl(50, 16%, 82%)",
                    16,
                    "hsl(230, 10%, 74%)"
                ],
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    14,
                    0.5,
                    20,
                    1
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {
                "line-join": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "transit",
                "mapbox:group": "Transit, bridges"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "structure"
                    ],
                    "bridge"
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "major_rail",
                        "minor_rail"
                    ],
                    true,
                    false
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "bridge-rail-tracks",
            "paint": {
                "line-color": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    13,
                    "hsl(50, 16%, 82%)",
                    16,
                    "hsl(230, 10%, 74%)"
                ],
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    14,
                    4,
                    20,
                    8
                ],
                "line-dasharray": [
                    0.1,
                    15
                ],
                "line-opacity": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    13.75,
                    0,
                    14,
                    1
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 12,
            "layout": {
                "line-join": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "transit",
                "mapbox:group": "Transit, elevated"
            },
            "filter": [
                "==",
                [
                    "get",
                    "class"
                ],
                "aerialway"
            ],
            "type": "line",
            "source": "composite",
            "id": "aerialway-bg",
            "paint": {
                "line-color": "hsl(0, 0%, 100%)",
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    14,
                    2.5,
                    20,
                    3
                ],
                "line-blur": 0.5
            },
            "source-layer": "road"
        },
        {
            "minzoom": 12,
            "layout": {
                "line-join": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "transit",
                "mapbox:group": "Transit, elevated"
            },
            "filter": [
                "==",
                [
                    "get",
                    "class"
                ],
                "aerialway"
            ],
            "type": "line",
            "source": "composite",
            "id": "aerialway",
            "paint": {
                "line-color": "hsl(230, 4%, 29%)",
                "line-width": [
                    "interpolate",
                    [
                        "exponential",
                        1.5
                    ],
                    [
                        "zoom"
                    ],
                    14,
                    0.5,
                    20,
                    1
                ]
            },
            "source-layer": "road"
        },
        {
            "id": "admin-1-boundary-bg",
            "type": "line",
            "source": "composite",
            "source-layer": "admin",
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "admin_level"
                    ],
                    1
                ],
                [
                    "==",
                    [
                        "get",
                        "maritime"
                    ],
                    "false"
                ],
                [
                    "match",
                    [
                        "get",
                        "worldview"
                    ],
                    [
                        "all",
                        "US"
                    ],
                    true,
                    false
                ]
            ],
            "layout": {
                "line-join": "bevel"
            },
            "paint": {
                "line-color": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    8,
                    "hsl(35, 9%, 91%)",
                    16,
                    "hsl(230, 49%, 91%)"
                ],
                "line-width": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    7,
                    3.75,
                    12,
                    5.5
                ],
                "line-opacity": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    7,
                    0,
                    8,
                    0.75
                ],
                "line-dasharray": [
                    1,
                    0
                ],
                "line-translate": [
                    0,
                    0
                ],
                "line-blur": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    3,
                    0,
                    8,
                    3
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "admin-boundaries",
                "mapbox:group": "Administrative boundaries, admin"
            }
        },
        {
            "minzoom": 1,
            "layout": {},
            "metadata": {
                "mapbox:featureComponent": "admin-boundaries",
                "mapbox:group": "Administrative boundaries, admin"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "admin_level"
                    ],
                    0
                ],
                [
                    "==",
                    [
                        "get",
                        "maritime"
                    ],
                    "false"
                ],
                [
                    "match",
                    [
                        "get",
                        "worldview"
                    ],
                    [
                        "all",
                        "US"
                    ],
                    true,
                    false
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "admin-0-boundary-bg",
            "paint": {
                "line-width": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    3,
                    3.5,
                    10,
                    8
                ],
                "line-color": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    6,
                    "hsl(35, 9%, 91%)",
                    8,
                    "hsl(230, 49%, 91%)"
                ],
                "line-opacity": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    3,
                    0,
                    4,
                    0.5
                ],
                "line-translate": [
                    0,
                    0
                ],
                "line-blur": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    3,
                    0,
                    10,
                    2
                ]
            },
            "source-layer": "admin"
        },
        {
            "id": "admin-1-boundary",
            "type": "line",
            "source": "composite",
            "source-layer": "admin",
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "admin_level"
                    ],
                    1
                ],
                [
                    "==",
                    [
                        "get",
                        "maritime"
                    ],
                    "false"
                ],
                [
                    "match",
                    [
                        "get",
                        "worldview"
                    ],
                    [
                        "all",
                        "US"
                    ],
                    true,
                    false
                ]
            ],
            "layout": {
                "line-join": "round",
                "line-cap": "round"
            },
            "paint": {
                "line-dasharray": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "literal",
                        [
                            2,
                            0
                        ]
                    ],
                    7,
                    [
                        "literal",
                        [
                            2,
                            2,
                            6,
                            2
                        ]
                    ]
                ],
                "line-width": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    7,
                    0.75,
                    12,
                    1.5
                ],
                "line-opacity": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    2,
                    0,
                    3,
                    1
                ],
                "line-color": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    3,
                    "hsl(230, 15%, 77%)",
                    7,
                    "hsl(230, 8%, 62%)"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "admin-boundaries",
                "mapbox:group": "Administrative boundaries, admin"
            }
        },
        {
            "minzoom": 1,
            "layout": {
                "line-join": "round",
                "line-cap": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "admin-boundaries",
                "mapbox:group": "Administrative boundaries, admin"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "admin_level"
                    ],
                    0
                ],
                [
                    "==",
                    [
                        "get",
                        "disputed"
                    ],
                    "false"
                ],
                [
                    "==",
                    [
                        "get",
                        "maritime"
                    ],
                    "false"
                ],
                [
                    "match",
                    [
                        "get",
                        "worldview"
                    ],
                    [
                        "all",
                        "US"
                    ],
                    true,
                    false
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "admin-0-boundary",
            "paint": {
                "line-color": "hsl(230, 8%, 51%)",
                "line-width": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    3,
                    0.5,
                    10,
                    2
                ],
                "line-dasharray": [
                    10,
                    0
                ]
            },
            "source-layer": "admin"
        },
        {
            "minzoom": 1,
            "layout": {
                "line-join": "round"
            },
            "metadata": {
                "mapbox:featureComponent": "admin-boundaries",
                "mapbox:group": "Administrative boundaries, admin"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "disputed"
                    ],
                    "true"
                ],
                [
                    "==",
                    [
                        "get",
                        "admin_level"
                    ],
                    0
                ],
                [
                    "==",
                    [
                        "get",
                        "maritime"
                    ],
                    "false"
                ],
                [
                    "match",
                    [
                        "get",
                        "worldview"
                    ],
                    [
                        "all",
                        "US"
                    ],
                    true,
                    false
                ]
            ],
            "type": "line",
            "source": "composite",
            "id": "admin-0-boundary-disputed",
            "paint": {
                "line-color": "hsl(230, 8%, 51%)",
                "line-width": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    3,
                    0.5,
                    10,
                    2
                ],
                "line-dasharray": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "literal",
                        [
                            3.25,
                            3.25
                        ]
                    ],
                    6,
                    [
                        "literal",
                        [
                            2.5,
                            2.5
                        ]
                    ],
                    7,
                    [
                        "literal",
                        [
                            2,
                            2.25
                        ]
                    ],
                    8,
                    [
                        "literal",
                        [
                            1.75,
                            2
                        ]
                    ]
                ]
            },
            "source-layer": "admin"
        },
        {
            "minzoom": 11,
            "layout": {
                "text-field": [
                    "concat",
                    [
                        "get",
                        "ele"
                    ],
                    " m"
                ],
                "symbol-placement": "line",
                "text-pitch-alignment": "viewport",
                "text-max-angle": 25,
                "text-padding": 5,
                "text-font": [
                    "DIN Pro Medium",
                    "Arial Unicode MS Regular"
                ],
                "text-size": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    13.299999999999999,
                    20,
                    16.799999999999997
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "terrain",
                "mapbox:group": "Terrain, terrain-labels"
            },
            "filter": [
                "any",
                [
                    "==",
                    [
                        "get",
                        "index"
                    ],
                    10
                ],
                [
                    "==",
                    [
                        "get",
                        "index"
                    ],
                    5
                ]
            ],
            "type": "symbol",
            "source": "composite",
            "id": "contour-label",
            "paint": {
                "text-color": "hsl(100, 86%, 21%)",
                "text-halo-width": 1,
                "text-halo-color": "hsla(35, 16%, 100%, 0.5)"
            },
            "source-layer": "contour"
        },
        {
            "id": "building-number-label",
            "type": "symbol",
            "source": "composite",
            "source-layer": "housenum_label",
            "minzoom": 17,
            "layout": {
                "text-field": [
                    "get",
                    "house_num"
                ],
                "text-font": [
                    "DIN Pro Italic",
                    "Arial Unicode MS Regular"
                ],
                "text-padding": 4,
                "text-max-width": 7,
                "text-size": 9.5
            },
            "paint": {
                "text-color": "hsl(35, 0%, 70%)",
                "text-halo-color": "hsl(35, 4%, 92%)",
                "text-halo-width": 0.5
            },
            "metadata": {
                "mapbox:featureComponent": "buildings",
                "mapbox:group": "Buildings, building-labels"
            }
        },
        {
            "minzoom": 16,
            "layout": {
                "text-field": [
                    "get",
                    "name"
                ],
                "text-font": [
                    "DIN Pro Italic",
                    "Arial Unicode MS Regular"
                ],
                "text-max-width": 7,
                "text-size": 11
            },
            "metadata": {
                "mapbox:featureComponent": "buildings",
                "mapbox:group": "Buildings, building-labels"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "class"
                    ],
                    "settlement_subdivision"
                ],
                [
                    "==",
                    [
                        "get",
                        "type"
                    ],
                    "block"
                ]
            ],
            "type": "symbol",
            "source": "composite",
            "id": "block-number-label",
            "paint": {
                "text-color": "hsl(35, 9%, 57%)",
                "text-halo-color": "hsl(35, 7%, 100%)",
                "text-halo-width": 0.5,
                "text-halo-blur": 0.5
            },
            "source-layer": "place_label"
        },
        {
            "minzoom": 10,
            "layout": {
                "text-size": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    10,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "motorway",
                            "trunk",
                            "primary",
                            "secondary",
                            "tertiary"
                        ],
                        12,
                        [
                            "motorway_link",
                            "trunk_link",
                            "primary_link",
                            "secondary_link",
                            "tertiary_link",
                            "street",
                            "street_limited",
                            "track"
                        ],
                        10.799999999999999,
                        7.8
                    ],
                    18,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        [
                            "motorway",
                            "trunk",
                            "primary",
                            "secondary",
                            "tertiary"
                        ],
                        19.2,
                        [
                            "motorway_link",
                            "trunk_link",
                            "primary_link",
                            "secondary_link",
                            "tertiary_link",
                            "street",
                            "street_limited"
                        ],
                        16.8,
                        15.6
                    ]
                ],
                "text-max-angle": 30,
                "text-font": [
                    "DIN Pro Regular",
                    "Arial Unicode MS Regular"
                ],
                "symbol-placement": "line",
                "text-padding": 1,
                "text-rotation-alignment": "map",
                "text-pitch-alignment": "viewport",
                "text-field": [
                    "coalesce",
                    [
                        "get",
                        "name_en"
                    ],
                    [
                        "get",
                        "name"
                    ]
                ],
                "text-letter-spacing": 0.01
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, road-labels"
            },
            "filter": [
                "step",
                [
                    "zoom"
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "motorway",
                        "trunk",
                        "primary",
                        "secondary",
                        "tertiary"
                    ],
                    true,
                    false
                ],
                12,
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "motorway",
                        "trunk",
                        "primary",
                        "secondary",
                        "tertiary",
                        "street",
                        "street_limited",
                        "track"
                    ],
                    true,
                    false
                ],
                15,
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "path",
                        "pedestrian",
                        "golf",
                        "ferry",
                        "aerialway"
                    ],
                    false,
                    true
                ]
            ],
            "type": "symbol",
            "source": "composite",
            "id": "road-label-outdoors",
            "paint": {
                "text-color": "hsl(0,0%, 0%)",
                "text-halo-color": [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "motorway",
                        "trunk"
                    ],
                    "hsla(35, 16%, 100%, 0.75)",
                    "hsl(35, 16%, 100%)"
                ],
                "text-halo-width": 1,
                "text-halo-blur": 1
            },
            "source-layer": "road"
        },
        {
            "minzoom": 15,
            "layout": {
                "text-field": [
                    "coalesce",
                    [
                        "get",
                        "name_en"
                    ],
                    [
                        "get",
                        "name"
                    ]
                ],
                "icon-image": "intersection",
                "icon-text-fit": "both",
                "icon-text-fit-padding": [
                    1,
                    2,
                    1,
                    2
                ],
                "text-size": [
                    "interpolate",
                    [
                        "exponential",
                        1.2
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    9,
                    18,
                    12
                ],
                "text-font": [
                    "DIN Pro Bold",
                    "Arial Unicode MS Bold"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, road-labels"
            },
            "filter": [
                "all",
                [
                    "==",
                    [
                        "get",
                        "class"
                    ],
                    "intersection"
                ],
                [
                    "has",
                    "name"
                ]
            ],
            "type": "symbol",
            "source": "composite",
            "id": "road-intersection",
            "paint": {
                "text-color": "hsl(230, 36%, 64%)"
            },
            "source-layer": "road"
        },
        {
            "minzoom": 6,
            "layout": {
                "text-size": 9,
                "icon-image": [
                    "concat",
                    [
                        "get",
                        "shield"
                    ],
                    "-",
                    [
                        "to-string",
                        [
                            "get",
                            "reflen"
                        ]
                    ]
                ],
                "icon-rotation-alignment": "viewport",
                "text-max-angle": 38,
                "symbol-spacing": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    11,
                    150,
                    14,
                    200
                ],
                "text-font": [
                    "DIN Pro Bold",
                    "Arial Unicode MS Bold"
                ],
                "symbol-placement": [
                    "step",
                    [
                        "zoom"
                    ],
                    "point",
                    11,
                    "line"
                ],
                "text-rotation-alignment": "viewport",
                "text-field": [
                    "get",
                    "ref"
                ],
                "text-letter-spacing": 0.05
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, road-labels"
            },
            "filter": [
                "all",
                [
                    "has",
                    "reflen"
                ],
                [
                    "<=",
                    [
                        "get",
                        "reflen"
                    ],
                    6
                ],
                [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "==",
                        [
                            "geometry-type"
                        ],
                        "Point"
                    ],
                    11,
                    [
                        ">",
                        [
                            "get",
                            "len"
                        ],
                        5000
                    ],
                    12,
                    [
                        ">",
                        [
                            "get",
                            "len"
                        ],
                        2500
                    ],
                    13,
                    [
                        ">",
                        [
                            "get",
                            "len"
                        ],
                        1000
                    ],
                    14,
                    true
                ]
            ],
            "type": "symbol",
            "source": "composite",
            "id": "road-number-shield",
            "paint": {
                "text-color": [
                    "match",
                    [
                        "get",
                        "shield_text_color"
                    ],
                    "white",
                    "hsl(0, 0%, 100%)",
                    "yellow",
                    "hsl(50, 63%, 70%)",
                    "orange",
                    "hsl(25, 63%, 75%)",
                    "blue",
                    "hsl(230, 36%, 44%)",
                    "hsl(230, 11%, 13%)"
                ]
            },
            "source-layer": "road"
        },
        {
            "minzoom": 14,
            "layout": {
                "text-field": [
                    "get",
                    "ref"
                ],
                "text-size": 9,
                "icon-image": [
                    "concat",
                    "motorway-exit-",
                    [
                        "to-string",
                        [
                            "get",
                            "reflen"
                        ]
                    ]
                ],
                "text-font": [
                    "DIN Pro Bold",
                    "Arial Unicode MS Bold"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "road-network",
                "mapbox:group": "Road network, road-labels"
            },
            "filter": [
                "all",
                [
                    "has",
                    "reflen"
                ],
                [
                    "<=",
                    [
                        "get",
                        "reflen"
                    ],
                    9
                ]
            ],
            "type": "symbol",
            "source": "composite",
            "id": "road-exit-shield",
            "paint": {
                "text-color": "hsl(0, 0%, 100%)",
                "text-translate": [
                    0,
                    0
                ]
            },
            "source-layer": "motorway_junction"
        },
        {
            "minzoom": 12,
            "layout": {
                "text-size": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    10,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        "pedestrian",
                        10.799999999999999,
                        7.8
                    ],
                    18,
                    [
                        "match",
                        [
                            "get",
                            "class"
                        ],
                        "pedestrian",
                        16.8,
                        15.6
                    ]
                ],
                "text-max-angle": 30,
                "text-font": [
                    "DIN Pro Regular",
                    "Arial Unicode MS Regular"
                ],
                "symbol-placement": "line",
                "text-padding": 1,
                "text-rotation-alignment": "map",
                "text-pitch-alignment": "viewport",
                "text-field": [
                    "coalesce",
                    [
                        "get",
                        "name_en"
                    ],
                    [
                        "get",
                        "name"
                    ]
                ],
                "text-letter-spacing": 0.01
            },
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., walking-cycling-labels"
            },
            "filter": [
                "step",
                [
                    "zoom"
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "pedestrian"
                    ],
                    true,
                    false
                ],
                15,
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "path",
                        "pedestrian"
                    ],
                    true,
                    false
                ]
            ],
            "type": "symbol",
            "source": "composite",
            "id": "path-pedestrian-label",
            "paint": {
                "text-color": "hsl(0,0%, 0%)",
                "text-halo-color": "hsl(0, 0%, 100%)",
                "text-halo-width": 1,
                "text-halo-blur": 1
            },
            "source-layer": "road"
        },
        {
            "minzoom": 16,
            "layout": {
                "text-field": [
                    "coalesce",
                    [
                        "get",
                        "name_en"
                    ],
                    [
                        "get",
                        "name"
                    ]
                ],
                "text-font": [
                    "DIN Pro Medium",
                    "Arial Unicode MS Regular"
                ],
                "text-size": 16.8
            },
            "metadata": {
                "mapbox:featureComponent": "walking-cycling",
                "mapbox:group": "Walking, cycling, etc., walking-cycling-labels"
            },
            "filter": [
                "==",
                [
                    "get",
                    "class"
                ],
                "golf"
            ],
            "type": "symbol",
            "source": "composite",
            "id": "golf-hole-label",
            "paint": {
                "text-halo-color": "hsl(99, 62%, 100%)",
                "text-halo-width": 0.5,
                "text-halo-blur": 0.5,
                "text-color": "hsl(100, 99%, 19%)"
            },
            "source-layer": "road"
        },
        {
            "minzoom": 15,
            "layout": {
                "text-size": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    10,
                    7.8,
                    18,
                    15.6
                ],
                "text-max-angle": 30,
                "text-font": [
                    "DIN Pro Regular",
                    "Arial Unicode MS Regular"
                ],
                "symbol-placement": "line",
                "text-padding": 1,
                "text-rotation-alignment": "map",
                "text-pitch-alignment": "viewport",
                "text-field": [
                    "coalesce",
                    [
                        "get",
                        "name_en"
                    ],
                    [
                        "get",
                        "name"
                    ]
                ],
                "text-letter-spacing": 0.01
            },
            "metadata": {
                "mapbox:featureComponent": "transit",
                "mapbox:group": "Transit, ferry-aerialway-labels"
            },
            "filter": [
                "match",
                [
                    "get",
                    "class"
                ],
                "aerialway",
                true,
                "ferry",
                true,
                false
            ],
            "type": "symbol",
            "source": "composite",
            "id": "ferry-aerialway-label",
            "paint": {
                "text-color": [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "ferry",
                    "hsl(196, 48%, 50%)",
                    "hsl(0,0%, 0%)"
                ],
                "text-halo-color": [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "ferry",
                    "hsl(196, 80%, 70%)",
                    "hsl(35, 16%, 100%)"
                ],
                "text-halo-width": 1,
                "text-halo-blur": 1
            },
            "source-layer": "road"
        },
        {
            "minzoom": 13,
            "layout": {
                "text-font": [
                    "DIN Pro Italic",
                    "Arial Unicode MS Regular"
                ],
                "text-max-angle": 30,
                "symbol-spacing": [
                    "interpolate",
                    [
                        "linear",
                        1
                    ],
                    [
                        "zoom"
                    ],
                    15,
                    250,
                    17,
                    400
                ],
                "text-size": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    13,
                    14.399999999999999,
                    18,
                    19.2
                ],
                "symbol-placement": "line",
                "text-pitch-alignment": "viewport",
                "text-field": [
                    "coalesce",
                    [
                        "get",
                        "name_en"
                    ],
                    [
                        "get",
                        "name"
                    ]
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "natural-features",
                "mapbox:group": "Natural features, natural-labels"
            },
            "filter": [
                "all",
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "canal",
                        "river",
                        "stream"
                    ],
                    [
                        "match",
                        [
                            "get",
                            "worldview"
                        ],
                        [
                            "all",
                            "US"
                        ],
                        true,
                        false
                    ],
                    [
                        "disputed_canal",
                        "disputed_river",
                        "disputed_stream"
                    ],
                    [
                        "all",
                        [
                            "==",
                            [
                                "get",
                                "disputed"
                            ],
                            "true"
                        ],
                        [
                            "match",
                            [
                                "get",
                                "worldview"
                            ],
                            [
                                "all",
                                "US"
                            ],
                            true,
                            false
                        ]
                    ],
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "type": "symbol",
            "source": "composite",
            "id": "waterway-label",
            "paint": {
                "text-color": "hsl(196, 48%, 57%)"
            },
            "source-layer": "natural_label"
        },
        {
            "minzoom": 4,
            "layout": {
                "text-size": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        25.2,
                        5,
                        16.799999999999997
                    ],
                    17,
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        25.2,
                        13,
                        16.799999999999997
                    ]
                ],
                "text-max-angle": 30,
                "text-field": [
                    "coalesce",
                    [
                        "get",
                        "name_en"
                    ],
                    [
                        "get",
                        "name"
                    ]
                ],
                "text-font": [
                    "DIN Pro Medium",
                    "Arial Unicode MS Regular"
                ],
                "symbol-placement": "line-center",
                "text-pitch-alignment": "viewport"
            },
            "metadata": {
                "mapbox:featureComponent": "natural-features",
                "mapbox:group": "Natural features, natural-labels"
            },
            "filter": [
                "all",
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "glacier",
                        "landform"
                    ],
                    [
                        "match",
                        [
                            "get",
                            "worldview"
                        ],
                        [
                            "all",
                            "US"
                        ],
                        true,
                        false
                    ],
                    [
                        "disputed_glacier",
                        "disputed_landform"
                    ],
                    [
                        "all",
                        [
                            "==",
                            [
                                "get",
                                "disputed"
                            ],
                            "true"
                        ],
                        [
                            "match",
                            [
                                "get",
                                "worldview"
                            ],
                            [
                                "all",
                                "US"
                            ],
                            true,
                            false
                        ]
                    ],
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ],
                [
                    "<=",
                    [
                        "get",
                        "filterrank"
                    ],
                    4
                ]
            ],
            "type": "symbol",
            "source": "composite",
            "id": "natural-line-label",
            "paint": {
                "text-halo-width": 0.5,
                "text-halo-color": "hsl(35, 16%, 100%)",
                "text-halo-blur": 0.5,
                "text-color": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        "hsl(26, 15%, 46%)",
                        5,
                        "hsl(26, 20%, 36%)"
                    ],
                    17,
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        "hsl(26, 15%, 46%)",
                        13,
                        "hsl(26, 20%, 36%)"
                    ]
                ]
            },
            "source-layer": "natural_label"
        },
        {
            "minzoom": 4,
            "layout": {
                "text-size": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        25.2,
                        5,
                        16.799999999999997
                    ],
                    17,
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        25.2,
                        13,
                        16.799999999999997
                    ]
                ],
                "icon-image": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "concat",
                        [
                            "get",
                            "maki"
                        ],
                        "-11"
                    ],
                    15,
                    [
                        "concat",
                        [
                            "get",
                            "maki"
                        ],
                        "-15"
                    ]
                ],
                "text-font": [
                    "DIN Pro Medium",
                    "Arial Unicode MS Regular"
                ],
                "text-offset": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        [
                            "literal",
                            [
                                0,
                                0
                            ]
                        ],
                        5,
                        [
                            "literal",
                            [
                                0,
                                0.75
                            ]
                        ]
                    ],
                    17,
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        [
                            "literal",
                            [
                                0,
                                0
                            ]
                        ],
                        13,
                        [
                            "literal",
                            [
                                0,
                                0.75
                            ]
                        ]
                    ]
                ],
                "text-anchor": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        "center",
                        5,
                        "top"
                    ],
                    17,
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        "center",
                        13,
                        "top"
                    ]
                ],
                "text-field": [
                    "coalesce",
                    [
                        "get",
                        "name_en"
                    ],
                    [
                        "get",
                        "name"
                    ]
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "natural-features",
                "mapbox:group": "Natural features, natural-labels"
            },
            "filter": [
                "all",
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "dock",
                        "glacier",
                        "landform",
                        "water_feature",
                        "wetland"
                    ],
                    [
                        "match",
                        [
                            "get",
                            "worldview"
                        ],
                        [
                            "all",
                            "US"
                        ],
                        true,
                        false
                    ],
                    [
                        "disputed_dock",
                        "disputed_glacier",
                        "disputed_landform",
                        "disputed_water_feature",
                        "disputed_wetland"
                    ],
                    [
                        "all",
                        [
                            "==",
                            [
                                "get",
                                "disputed"
                            ],
                            "true"
                        ],
                        [
                            "match",
                            [
                                "get",
                                "worldview"
                            ],
                            [
                                "all",
                                "US"
                            ],
                            true,
                            false
                        ]
                    ],
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "Point"
                ],
                [
                    "<=",
                    [
                        "get",
                        "filterrank"
                    ],
                    4
                ]
            ],
            "type": "symbol",
            "source": "composite",
            "id": "natural-point-label",
            "paint": {
                "icon-opacity": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        0,
                        5,
                        1
                    ],
                    17,
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        0,
                        13,
                        1
                    ]
                ],
                "text-halo-color": "hsl(35, 16%, 100%)",
                "text-halo-width": 0.5,
                "text-halo-blur": 0.5,
                "text-color": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        "hsl(26, 15%, 46%)",
                        5,
                        "hsl(26, 20%, 36%)"
                    ],
                    17,
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        "hsl(26, 15%, 46%)",
                        13,
                        "hsl(26, 20%, 36%)"
                    ]
                ]
            },
            "source-layer": "natural_label"
        },
        {
            "id": "water-line-label",
            "type": "symbol",
            "metadata": {
                "mapbox:featureComponent": "natural-features",
                "mapbox:group": "Natural features, natural-labels"
            },
            "source": "composite",
            "source-layer": "natural_label",
            "filter": [
                "all",
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "bay",
                        "ocean",
                        "reservoir",
                        "sea",
                        "water"
                    ],
                    [
                        "match",
                        [
                            "get",
                            "worldview"
                        ],
                        [
                            "all",
                            "US"
                        ],
                        true,
                        false
                    ],
                    [
                        "disputed_bay",
                        "disputed_ocean",
                        "disputed_reservoir",
                        "disputed_sea",
                        "disputed_water"
                    ],
                    [
                        "all",
                        [
                            "==",
                            [
                                "get",
                                "disputed"
                            ],
                            "true"
                        ],
                        [
                            "match",
                            [
                                "get",
                                "worldview"
                            ],
                            [
                                "all",
                                "US"
                            ],
                            true,
                            false
                        ]
                    ],
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "LineString"
                ]
            ],
            "layout": {
                "text-size": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    7,
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        28.799999999999997,
                        6,
                        21.599999999999998,
                        12,
                        14.399999999999999
                    ],
                    10,
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        21.599999999999998,
                        9,
                        14.399999999999999
                    ],
                    18,
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        21.599999999999998,
                        9,
                        19.2
                    ]
                ],
                "text-max-angle": 30,
                "text-letter-spacing": [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "ocean",
                    0.25,
                    [
                        "sea",
                        "bay"
                    ],
                    0.15,
                    0
                ],
                "text-font": [
                    "DIN Pro Italic",
                    "Arial Unicode MS Regular"
                ],
                "symbol-placement": "line-center",
                "text-pitch-alignment": "viewport",
                "text-field": [
                    "coalesce",
                    [
                        "get",
                        "name_en"
                    ],
                    [
                        "get",
                        "name"
                    ]
                ]
            },
            "paint": {
                "text-color": [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "bay",
                        "ocean",
                        "sea"
                    ],
                    "hsl(196, 76%, 50%)",
                    "hsl(196, 48%, 57%)"
                ]
            }
        },
        {
            "id": "water-point-label",
            "type": "symbol",
            "source": "composite",
            "source-layer": "natural_label",
            "filter": [
                "all",
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "bay",
                        "ocean",
                        "reservoir",
                        "sea",
                        "water"
                    ],
                    [
                        "match",
                        [
                            "get",
                            "worldview"
                        ],
                        [
                            "all",
                            "US"
                        ],
                        true,
                        false
                    ],
                    [
                        "disputed_bay",
                        "disputed_ocean",
                        "disputed_reservoir",
                        "disputed_sea",
                        "disputed_water"
                    ],
                    [
                        "all",
                        [
                            "==",
                            [
                                "get",
                                "disputed"
                            ],
                            "true"
                        ],
                        [
                            "match",
                            [
                                "get",
                                "worldview"
                            ],
                            [
                                "all",
                                "US"
                            ],
                            true,
                            false
                        ]
                    ],
                    false
                ],
                [
                    "==",
                    [
                        "geometry-type"
                    ],
                    "Point"
                ]
            ],
            "layout": {
                "text-line-height": 1.3,
                "text-size": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    7,
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        28.799999999999997,
                        6,
                        21.599999999999998,
                        12,
                        14.399999999999999
                    ],
                    10,
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        21.599999999999998,
                        9,
                        14.399999999999999
                    ]
                ],
                "text-font": [
                    "DIN Pro Italic",
                    "Arial Unicode MS Regular"
                ],
                "text-field": [
                    "coalesce",
                    [
                        "get",
                        "name_en"
                    ],
                    [
                        "get",
                        "name"
                    ]
                ],
                "text-letter-spacing": [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "ocean",
                    0.25,
                    [
                        "bay",
                        "sea"
                    ],
                    0.15,
                    0.01
                ],
                "text-max-width": [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "ocean",
                    4,
                    "sea",
                    5,
                    [
                        "bay",
                        "water"
                    ],
                    7,
                    10
                ]
            },
            "paint": {
                "text-color": [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    [
                        "bay",
                        "ocean",
                        "sea"
                    ],
                    "hsl(196, 76%, 50%)",
                    "hsl(196, 48%, 57%)"
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "natural-features",
                "mapbox:group": "Natural features, natural-labels"
            }
        },
        {
            "minzoom": 6,
            "layout": {
                "text-size": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        25.2,
                        5,
                        16.799999999999997
                    ],
                    17,
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        25.2,
                        13,
                        16.799999999999997
                    ]
                ],
                "icon-image": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "concat",
                        [
                            "get",
                            "maki"
                        ],
                        "-11"
                    ],
                    15,
                    [
                        "concat",
                        [
                            "get",
                            "maki"
                        ],
                        "-15"
                    ]
                ],
                "text-font": [
                    "DIN Pro Medium",
                    "Arial Unicode MS Regular"
                ],
                "text-offset": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        [
                            "literal",
                            [
                                0,
                                0
                            ]
                        ],
                        5,
                        [
                            "literal",
                            [
                                0,
                                0.75
                            ]
                        ]
                    ],
                    17,
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        [
                            "literal",
                            [
                                0,
                                0
                            ]
                        ],
                        13,
                        [
                            "literal",
                            [
                                0,
                                0.75
                            ]
                        ]
                    ]
                ],
                "text-anchor": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        "center",
                        5,
                        "top"
                    ],
                    17,
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        "center",
                        13,
                        "top"
                    ]
                ],
                "text-field": [
                    "coalesce",
                    [
                        "get",
                        "name_en"
                    ],
                    [
                        "get",
                        "name"
                    ]
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "point-of-interest-labels",
                "mapbox:group": "Point of interest labels, poi-labels"
            },
            "filter": [
                "let",
                "densityByClass",
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "arts_and_entertainment",
                    3,
                    "historic",
                    4,
                    "landmark",
                    3,
                    "lodging",
                    1,
                    "medical",
                    1,
                    "park_like",
                    4,
                    "place_like",
                    3,
                    "sport_and_leisure",
                    4,
                    "visitor_amenities",
                    4,
                    2
                ],
                [
                    "<=",
                    [
                        "get",
                        "filterrank"
                    ],
                    [
                        "case",
                        [
                            "<",
                            0,
                            [
                                "var",
                                "densityByClass"
                            ]
                        ],
                        [
                            "+",
                            [
                                "step",
                                [
                                    "zoom"
                                ],
                                0,
                                16,
                                1,
                                17,
                                2
                            ],
                            [
                                "var",
                                "densityByClass"
                            ]
                        ],
                        [
                            "var",
                            "densityByClass"
                        ]
                    ]
                ]
            ],
            "type": "symbol",
            "source": "composite",
            "id": "poi-label",
            "paint": {
                "icon-opacity": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        0,
                        5,
                        1
                    ],
                    17,
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        0,
                        13,
                        1
                    ]
                ],
                "text-halo-color": [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "park_like",
                    "hsl(99, 62%, 100%)",
                    "education",
                    "hsl(50, 61%, 100%)",
                    "medical",
                    "hsl(340, 37%, 100%)",
                    "hsl(35, 16%, 100%)"
                ],
                "text-halo-width": 0.5,
                "text-halo-blur": 0.5,
                "text-color": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        [
                            "match",
                            [
                                "get",
                                "class"
                            ],
                            "food_and_drink",
                            "hsl(22, 44%, 59%)",
                            "park_like",
                            "hsl(100, 100%, 30%)",
                            "education",
                            "hsl(50, 40%, 43%)",
                            "medical",
                            "hsl(340, 15%, 52%)",
                            "hsl(26, 15%, 46%)"
                        ],
                        5,
                        [
                            "match",
                            [
                                "get",
                                "class"
                            ],
                            "food_and_drink",
                            "hsl(22, 68%, 42%)",
                            "park_like",
                            "hsl(100, 99%, 19%)",
                            "education",
                            "hsl(50, 100%, 23%)",
                            "medical",
                            "hsl(340, 19%, 42%)",
                            "hsl(26, 20%, 36%)"
                        ]
                    ],
                    17,
                    [
                        "step",
                        [
                            "get",
                            "sizerank"
                        ],
                        [
                            "match",
                            [
                                "get",
                                "class"
                            ],
                            "food_and_drink",
                            "hsl(22, 44%, 59%)",
                            "park_like",
                            "hsl(100, 100%, 30%)",
                            "education",
                            "hsl(50, 40%, 43%)",
                            "medical",
                            "hsl(340, 15%, 52%)",
                            "hsl(26, 15%, 46%)"
                        ],
                        13,
                        [
                            "match",
                            [
                                "get",
                                "class"
                            ],
                            "food_and_drink",
                            "hsl(22, 68%, 42%)",
                            "park_like",
                            "hsl(100, 99%, 19%)",
                            "education",
                            "hsl(50, 100%, 23%)",
                            "medical",
                            "hsl(340, 19%, 42%)",
                            "hsl(26, 20%, 36%)"
                        ]
                    ]
                ]
            },
            "source-layer": "poi_label"
        },
        {
            "minzoom": 12,
            "layout": {
                "text-size": 16.8,
                "icon-image": [
                    "get",
                    "network"
                ],
                "text-font": [
                    "DIN Pro Medium",
                    "Arial Unicode MS Regular"
                ],
                "text-justify": [
                    "match",
                    [
                        "get",
                        "stop_type"
                    ],
                    "entrance",
                    "left",
                    "center"
                ],
                "text-offset": [
                    "match",
                    [
                        "get",
                        "stop_type"
                    ],
                    "entrance",
                    [
                        "literal",
                        [
                            1,
                            0
                        ]
                    ],
                    [
                        "literal",
                        [
                            0,
                            0.8
                        ]
                    ]
                ],
                "text-anchor": [
                    "match",
                    [
                        "get",
                        "stop_type"
                    ],
                    "entrance",
                    "left",
                    "top"
                ],
                "text-field": [
                    "step",
                    [
                        "zoom"
                    ],
                    "",
                    14,
                    [
                        "match",
                        [
                            "get",
                            "mode"
                        ],
                        [
                            "rail",
                            "metro_rail"
                        ],
                        [
                            "coalesce",
                            [
                                "get",
                                "name_en"
                            ],
                            [
                                "get",
                                "name"
                            ]
                        ],
                        ""
                    ],
                    16,
                    [
                        "match",
                        [
                            "get",
                            "mode"
                        ],
                        [
                            "bus",
                            "bicycle"
                        ],
                        "",
                        [
                            "coalesce",
                            [
                                "get",
                                "name_en"
                            ],
                            [
                                "get",
                                "name"
                            ]
                        ]
                    ],
                    18,
                    [
                        "coalesce",
                        [
                            "get",
                            "name_en"
                        ],
                        [
                            "get",
                            "name"
                        ]
                    ]
                ],
                "text-letter-spacing": 0.01,
                "text-max-width": [
                    "match",
                    [
                        "get",
                        "stop_type"
                    ],
                    "entrance",
                    15,
                    9
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "transit",
                "mapbox:group": "Transit, transit-labels"
            },
            "filter": [
                "step",
                [
                    "zoom"
                ],
                [
                    "all",
                    [
                        "match",
                        [
                            "get",
                            "mode"
                        ],
                        "rail",
                        true,
                        "metro_rail",
                        true,
                        false
                    ],
                    [
                        "!=",
                        [
                            "get",
                            "stop_type"
                        ],
                        "entrance"
                    ]
                ],
                15,
                [
                    "all",
                    [
                        "match",
                        [
                            "get",
                            "mode"
                        ],
                        "rail",
                        true,
                        "metro_rail",
                        true,
                        "ferry",
                        true,
                        "light_rail",
                        true,
                        false
                    ],
                    [
                        "!=",
                        [
                            "get",
                            "stop_type"
                        ],
                        "entrance"
                    ]
                ],
                16,
                [
                    "all",
                    [
                        "match",
                        [
                            "get",
                            "mode"
                        ],
                        "bus",
                        false,
                        true
                    ],
                    [
                        "!=",
                        [
                            "get",
                            "stop_type"
                        ],
                        "entrance"
                    ]
                ],
                17,
                [
                    "!=",
                    [
                        "get",
                        "stop_type"
                    ],
                    "entrance"
                ],
                19,
                true
            ],
            "type": "symbol",
            "source": "composite",
            "id": "transit-label",
            "paint": {
                "text-halo-color": "hsl(35, 16%, 100%)",
                "text-color": [
                    "match",
                    [
                        "get",
                        "network"
                    ],
                    "tokyo-metro",
                    "hsl(180, 30%, 30%)",
                    "mexico-city-metro",
                    "hsl(25, 63%, 63%)",
                    [
                        "barcelona-metro",
                        "delhi-metro",
                        "hong-kong-mtr",
                        "milan-metro",
                        "osaka-subway"
                    ],
                    "hsl(0, 57%, 47%)",
                    [
                        "boston-t",
                        "washington-metro"
                    ],
                    "hsl(230, 11%, 20%)",
                    [
                        "chongqing-rail-transit",
                        "kiev-metro",
                        "singapore-mrt",
                        "taipei-metro"
                    ],
                    "hsl(140, 56%, 25%)",
                    "hsl(230, 48%, 50%)"
                ],
                "text-halo-blur": 0.5,
                "text-halo-width": 0.5
            },
            "source-layer": "transit_stop_label"
        },
        {
            "minzoom": 8,
            "layout": {
                "text-line-height": 1.1,
                "text-size": [
                    "step",
                    [
                        "get",
                        "sizerank"
                    ],
                    25.2,
                    9,
                    16.799999999999997
                ],
                "icon-image": [
                    "step",
                    [
                        "get",
                        "sizerank"
                    ],
                    [
                        "concat",
                        [
                            "get",
                            "maki"
                        ],
                        "-15"
                    ],
                    9,
                    [
                        "concat",
                        [
                            "get",
                            "maki"
                        ],
                        "-11"
                    ]
                ],
                "text-font": [
                    "DIN Pro Medium",
                    "Arial Unicode MS Regular"
                ],
                "text-offset": [
                    0,
                    0.75
                ],
                "text-rotation-alignment": "viewport",
                "text-anchor": "top",
                "text-field": [
                    "step",
                    [
                        "get",
                        "sizerank"
                    ],
                    [
                        "coalesce",
                        [
                            "get",
                            "name_en"
                        ],
                        [
                            "get",
                            "name"
                        ]
                    ],
                    15,
                    [
                        "get",
                        "ref"
                    ]
                ],
                "text-letter-spacing": 0.01,
                "text-max-width": 9
            },
            "metadata": {
                "mapbox:featureComponent": "transit",
                "mapbox:group": "Transit, transit-labels"
            },
            "filter": [
                "match",
                [
                    "get",
                    "class"
                ],
                [
                    "military",
                    "civil"
                ],
                [
                    "match",
                    [
                        "get",
                        "worldview"
                    ],
                    [
                        "all",
                        "US"
                    ],
                    true,
                    false
                ],
                [
                    "disputed_military",
                    "disputed_civil"
                ],
                [
                    "all",
                    [
                        "==",
                        [
                            "get",
                            "disputed"
                        ],
                        "true"
                    ],
                    [
                        "match",
                        [
                            "get",
                            "worldview"
                        ],
                        [
                            "all",
                            "US"
                        ],
                        true,
                        false
                    ]
                ],
                false
            ],
            "type": "symbol",
            "source": "composite",
            "id": "airport-label",
            "paint": {
                "text-color": "hsl(230, 48%, 44%)",
                "text-halo-color": "hsl(230, 31%, 100%)",
                "text-halo-width": 1
            },
            "source-layer": "airport_label"
        },
        {
            "minzoom": 10,
            "layout": {
                "text-field": [
                    "coalesce",
                    [
                        "get",
                        "name_en"
                    ],
                    [
                        "get",
                        "name"
                    ]
                ],
                "text-transform": "uppercase",
                "text-font": [
                    "DIN Pro Regular",
                    "Arial Unicode MS Regular"
                ],
                "text-letter-spacing": [
                    "match",
                    [
                        "get",
                        "type"
                    ],
                    "suburb",
                    0.15,
                    0.1
                ],
                "text-max-width": 7,
                "text-padding": 3,
                "text-size": [
                    "interpolate",
                    [
                        "cubic-bezier",
                        0.5,
                        0,
                        1,
                        1
                    ],
                    [
                        "zoom"
                    ],
                    11,
                    [
                        "match",
                        [
                            "get",
                            "type"
                        ],
                        "suburb",
                        13.2,
                        12.6
                    ],
                    15,
                    [
                        "match",
                        [
                            "get",
                            "type"
                        ],
                        "suburb",
                        20.4,
                        19.2
                    ]
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "place-labels",
                "mapbox:group": "Place labels, place-labels"
            },
            "maxzoom": 15,
            "filter": [
                "all",
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "settlement_subdivision",
                    [
                        "match",
                        [
                            "get",
                            "worldview"
                        ],
                        [
                            "all",
                            "US"
                        ],
                        true,
                        false
                    ],
                    "disputed_settlement_subdivision",
                    [
                        "all",
                        [
                            "==",
                            [
                                "get",
                                "disputed"
                            ],
                            "true"
                        ],
                        [
                            "match",
                            [
                                "get",
                                "worldview"
                            ],
                            [
                                "all",
                                "US"
                            ],
                            true,
                            false
                        ]
                    ],
                    false
                ],
                [
                    "<=",
                    [
                        "get",
                        "filterrank"
                    ],
                    4
                ]
            ],
            "type": "symbol",
            "source": "composite",
            "id": "settlement-subdivision-label",
            "paint": {
                "text-halo-color": "hsla(35, 16%, 100%, 0.75)",
                "text-halo-width": 1,
                "text-color": "hsl(230, 29%, 36%)",
                "text-halo-blur": 0.5
            },
            "source-layer": "place_label"
        },
        {
            "layout": {
                "text-line-height": 1.1,
                "text-size": [
                    "interpolate",
                    [
                        "cubic-bezier",
                        0.2,
                        0,
                        0.9,
                        1
                    ],
                    [
                        "zoom"
                    ],
                    3,
                    [
                        "step",
                        [
                            "get",
                            "symbolrank"
                        ],
                        14.399999999999999,
                        9,
                        13.2,
                        10,
                        12.6,
                        12,
                        11.4,
                        14,
                        10.2,
                        16,
                        7.8,
                        17,
                        4.8
                    ],
                    13,
                    [
                        "step",
                        [
                            "get",
                            "symbolrank"
                        ],
                        30,
                        9,
                        27.599999999999998,
                        10,
                        25.2,
                        11,
                        22.8,
                        12,
                        21.599999999999998,
                        13,
                        20.4,
                        15,
                        18
                    ]
                ],
                "icon-image": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "case",
                        [
                            "==",
                            [
                                "get",
                                "capital"
                            ],
                            2
                        ],
                        "border-dot-13",
                        [
                            "step",
                            [
                                "get",
                                "symbolrank"
                            ],
                            "dot-11",
                            9,
                            "dot-10",
                            11,
                            "dot-9"
                        ]
                    ],
                    8,
                    ""
                ],
                "text-font": [
                    "DIN Pro Regular",
                    "Arial Unicode MS Regular"
                ],
                "text-justify": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "match",
                        [
                            "get",
                            "text_anchor"
                        ],
                        [
                            "left",
                            "bottom-left",
                            "top-left"
                        ],
                        "left",
                        [
                            "right",
                            "bottom-right",
                            "top-right"
                        ],
                        "right",
                        "center"
                    ],
                    8,
                    "center"
                ],
                "text-offset": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "match",
                        [
                            "get",
                            "capital"
                        ],
                        2,
                        [
                            "match",
                            [
                                "get",
                                "text_anchor"
                            ],
                            "bottom",
                            [
                                "literal",
                                [
                                    0,
                                    -0.3
                                ]
                            ],
                            "bottom-left",
                            [
                                "literal",
                                [
                                    0.3,
                                    -0.1
                                ]
                            ],
                            "left",
                            [
                                "literal",
                                [
                                    0.45,
                                    0.1
                                ]
                            ],
                            "top-left",
                            [
                                "literal",
                                [
                                    0.3,
                                    0.1
                                ]
                            ],
                            "top",
                            [
                                "literal",
                                [
                                    0,
                                    0.3
                                ]
                            ],
                            "top-right",
                            [
                                "literal",
                                [
                                    -0.3,
                                    0.1
                                ]
                            ],
                            "right",
                            [
                                "literal",
                                [
                                    -0.45,
                                    0
                                ]
                            ],
                            "bottom-right",
                            [
                                "literal",
                                [
                                    -0.3,
                                    -0.1
                                ]
                            ],
                            [
                                "literal",
                                [
                                    0,
                                    -0.3
                                ]
                            ]
                        ],
                        [
                            "match",
                            [
                                "get",
                                "text_anchor"
                            ],
                            "bottom",
                            [
                                "literal",
                                [
                                    0,
                                    -0.25
                                ]
                            ],
                            "bottom-left",
                            [
                                "literal",
                                [
                                    0.2,
                                    -0.05
                                ]
                            ],
                            "left",
                            [
                                "literal",
                                [
                                    0.4,
                                    0.05
                                ]
                            ],
                            "top-left",
                            [
                                "literal",
                                [
                                    0.2,
                                    0.05
                                ]
                            ],
                            "top",
                            [
                                "literal",
                                [
                                    0,
                                    0.25
                                ]
                            ],
                            "top-right",
                            [
                                "literal",
                                [
                                    -0.2,
                                    0.05
                                ]
                            ],
                            "right",
                            [
                                "literal",
                                [
                                    -0.4,
                                    0.05
                                ]
                            ],
                            "bottom-right",
                            [
                                "literal",
                                [
                                    -0.2,
                                    -0.05
                                ]
                            ],
                            [
                                "literal",
                                [
                                    0,
                                    -0.25
                                ]
                            ]
                        ]
                    ],
                    8,
                    [
                        "literal",
                        [
                            0,
                            0
                        ]
                    ]
                ],
                "text-anchor": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "get",
                        "text_anchor"
                    ],
                    8,
                    "center"
                ],
                "text-field": [
                    "coalesce",
                    [
                        "get",
                        "name_en"
                    ],
                    [
                        "get",
                        "name"
                    ]
                ],
                "text-max-width": 7
            },
            "metadata": {
                "mapbox:featureComponent": "place-labels",
                "mapbox:group": "Place labels, place-labels"
            },
            "maxzoom": 15,
            "filter": [
                "all",
                [
                    "<=",
                    [
                        "get",
                        "filterrank"
                    ],
                    3
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "settlement",
                    [
                        "match",
                        [
                            "get",
                            "worldview"
                        ],
                        [
                            "all",
                            "US"
                        ],
                        true,
                        false
                    ],
                    "disputed_settlement",
                    [
                        "all",
                        [
                            "==",
                            [
                                "get",
                                "disputed"
                            ],
                            "true"
                        ],
                        [
                            "match",
                            [
                                "get",
                                "worldview"
                            ],
                            [
                                "all",
                                "US"
                            ],
                            true,
                            false
                        ]
                    ],
                    false
                ],
                [
                    "step",
                    [
                        "zoom"
                    ],
                    true,
                    8,
                    [
                        ">=",
                        [
                            "get",
                            "symbolrank"
                        ],
                        11
                    ],
                    10,
                    [
                        ">=",
                        [
                            "get",
                            "symbolrank"
                        ],
                        12
                    ],
                    11,
                    [
                        ">=",
                        [
                            "get",
                            "symbolrank"
                        ],
                        13
                    ],
                    12,
                    [
                        ">=",
                        [
                            "get",
                            "symbolrank"
                        ],
                        15
                    ],
                    13,
                    [
                        ">=",
                        [
                            "get",
                            "symbolrank"
                        ],
                        11
                    ],
                    14,
                    [
                        ">=",
                        [
                            "get",
                            "symbolrank"
                        ],
                        13
                    ]
                ]
            ],
            "type": "symbol",
            "source": "composite",
            "id": "settlement-minor-label",
            "paint": {
                "text-color": "hsl(230, 29%, 0%)",
                "text-halo-color": "hsl(35, 16%, 100%)",
                "text-halo-width": 1,
                "text-halo-blur": 1
            },
            "source-layer": "place_label"
        },
        {
            "layout": {
                "text-line-height": 1.1,
                "text-size": [
                    "interpolate",
                    [
                        "cubic-bezier",
                        0.2,
                        0,
                        0.9,
                        1
                    ],
                    [
                        "zoom"
                    ],
                    8,
                    [
                        "step",
                        [
                            "get",
                            "symbolrank"
                        ],
                        21.599999999999998,
                        9,
                        20.4,
                        10,
                        18
                    ],
                    15,
                    [
                        "step",
                        [
                            "get",
                            "symbolrank"
                        ],
                        33.6,
                        9,
                        31.2,
                        10,
                        27.599999999999998,
                        11,
                        25.2,
                        12,
                        24,
                        13,
                        22.8,
                        15,
                        19.2
                    ]
                ],
                "icon-image": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "case",
                        [
                            "==",
                            [
                                "get",
                                "capital"
                            ],
                            2
                        ],
                        "border-dot-13",
                        [
                            "step",
                            [
                                "get",
                                "symbolrank"
                            ],
                            "dot-11",
                            9,
                            "dot-10",
                            11,
                            "dot-9"
                        ]
                    ],
                    8,
                    ""
                ],
                "text-font": [
                    "DIN Pro Medium",
                    "Arial Unicode MS Regular"
                ],
                "text-justify": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "match",
                        [
                            "get",
                            "text_anchor"
                        ],
                        [
                            "left",
                            "bottom-left",
                            "top-left"
                        ],
                        "left",
                        [
                            "right",
                            "bottom-right",
                            "top-right"
                        ],
                        "right",
                        "center"
                    ],
                    8,
                    "center"
                ],
                "text-offset": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "match",
                        [
                            "get",
                            "capital"
                        ],
                        2,
                        [
                            "match",
                            [
                                "get",
                                "text_anchor"
                            ],
                            "bottom",
                            [
                                "literal",
                                [
                                    0,
                                    -0.3
                                ]
                            ],
                            "bottom-left",
                            [
                                "literal",
                                [
                                    0.3,
                                    -0.1
                                ]
                            ],
                            "left",
                            [
                                "literal",
                                [
                                    0.45,
                                    0.1
                                ]
                            ],
                            "top-left",
                            [
                                "literal",
                                [
                                    0.3,
                                    0.1
                                ]
                            ],
                            "top",
                            [
                                "literal",
                                [
                                    0,
                                    0.3
                                ]
                            ],
                            "top-right",
                            [
                                "literal",
                                [
                                    -0.3,
                                    0.1
                                ]
                            ],
                            "right",
                            [
                                "literal",
                                [
                                    -0.45,
                                    0
                                ]
                            ],
                            "bottom-right",
                            [
                                "literal",
                                [
                                    -0.3,
                                    -0.1
                                ]
                            ],
                            [
                                "literal",
                                [
                                    0,
                                    -0.3
                                ]
                            ]
                        ],
                        [
                            "match",
                            [
                                "get",
                                "text_anchor"
                            ],
                            "bottom",
                            [
                                "literal",
                                [
                                    0,
                                    -0.25
                                ]
                            ],
                            "bottom-left",
                            [
                                "literal",
                                [
                                    0.2,
                                    -0.05
                                ]
                            ],
                            "left",
                            [
                                "literal",
                                [
                                    0.4,
                                    0.05
                                ]
                            ],
                            "top-left",
                            [
                                "literal",
                                [
                                    0.2,
                                    0.05
                                ]
                            ],
                            "top",
                            [
                                "literal",
                                [
                                    0,
                                    0.25
                                ]
                            ],
                            "top-right",
                            [
                                "literal",
                                [
                                    -0.2,
                                    0.05
                                ]
                            ],
                            "right",
                            [
                                "literal",
                                [
                                    -0.4,
                                    0.05
                                ]
                            ],
                            "bottom-right",
                            [
                                "literal",
                                [
                                    -0.2,
                                    -0.05
                                ]
                            ],
                            [
                                "literal",
                                [
                                    0,
                                    -0.25
                                ]
                            ]
                        ]
                    ],
                    8,
                    [
                        "literal",
                        [
                            0,
                            0
                        ]
                    ]
                ],
                "text-anchor": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "get",
                        "text_anchor"
                    ],
                    8,
                    "center"
                ],
                "text-field": [
                    "coalesce",
                    [
                        "get",
                        "name_en"
                    ],
                    [
                        "get",
                        "name"
                    ]
                ],
                "text-max-width": 7
            },
            "metadata": {
                "mapbox:featureComponent": "place-labels",
                "mapbox:group": "Place labels, place-labels"
            },
            "maxzoom": 15,
            "filter": [
                "all",
                [
                    "<=",
                    [
                        "get",
                        "filterrank"
                    ],
                    3
                ],
                [
                    "match",
                    [
                        "get",
                        "class"
                    ],
                    "settlement",
                    [
                        "match",
                        [
                            "get",
                            "worldview"
                        ],
                        [
                            "all",
                            "US"
                        ],
                        true,
                        false
                    ],
                    "disputed_settlement",
                    [
                        "all",
                        [
                            "==",
                            [
                                "get",
                                "disputed"
                            ],
                            "true"
                        ],
                        [
                            "match",
                            [
                                "get",
                                "worldview"
                            ],
                            [
                                "all",
                                "US"
                            ],
                            true,
                            false
                        ]
                    ],
                    false
                ],
                [
                    "step",
                    [
                        "zoom"
                    ],
                    false,
                    8,
                    [
                        "<",
                        [
                            "get",
                            "symbolrank"
                        ],
                        11
                    ],
                    10,
                    [
                        "<",
                        [
                            "get",
                            "symbolrank"
                        ],
                        12
                    ],
                    11,
                    [
                        "<",
                        [
                            "get",
                            "symbolrank"
                        ],
                        13
                    ],
                    12,
                    [
                        "<",
                        [
                            "get",
                            "symbolrank"
                        ],
                        15
                    ],
                    13,
                    [
                        ">=",
                        [
                            "get",
                            "symbolrank"
                        ],
                        11
                    ],
                    14,
                    [
                        ">=",
                        [
                            "get",
                            "symbolrank"
                        ],
                        13
                    ]
                ]
            ],
            "type": "symbol",
            "source": "composite",
            "id": "settlement-major-label",
            "paint": {
                "text-color": "hsl(230, 29%, 0%)",
                "text-halo-color": "hsl(35, 16%, 100%)",
                "text-halo-width": 1,
                "text-halo-blur": 1
            },
            "source-layer": "place_label"
        },
        {
            "minzoom": 3,
            "layout": {
                "text-size": [
                    "interpolate",
                    [
                        "cubic-bezier",
                        0.85,
                        0.7,
                        0.65,
                        1
                    ],
                    [
                        "zoom"
                    ],
                    4,
                    [
                        "step",
                        [
                            "get",
                            "symbolrank"
                        ],
                        12,
                        6,
                        11.4,
                        7,
                        10.799999999999999
                    ],
                    9,
                    [
                        "step",
                        [
                            "get",
                            "symbolrank"
                        ],
                        28.799999999999997,
                        6,
                        21.599999999999998,
                        7,
                        16.8
                    ]
                ],
                "text-transform": "uppercase",
                "text-font": [
                    "DIN Pro Bold",
                    "Arial Unicode MS Bold"
                ],
                "text-field": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "step",
                        [
                            "get",
                            "symbolrank"
                        ],
                        [
                            "coalesce",
                            [
                                "get",
                                "name_en"
                            ],
                            [
                                "get",
                                "name"
                            ]
                        ],
                        5,
                        [
                            "coalesce",
                            [
                                "get",
                                "abbr"
                            ],
                            [
                                "get",
                                "name_en"
                            ],
                            [
                                "get",
                                "name"
                            ]
                        ]
                    ],
                    5,
                    [
                        "coalesce",
                        [
                            "get",
                            "name_en"
                        ],
                        [
                            "get",
                            "name"
                        ]
                    ]
                ],
                "text-letter-spacing": 0.15,
                "text-max-width": 6
            },
            "metadata": {
                "mapbox:featureComponent": "place-labels",
                "mapbox:group": "Place labels, place-labels"
            },
            "maxzoom": 9,
            "filter": [
                "match",
                [
                    "get",
                    "class"
                ],
                "state",
                [
                    "match",
                    [
                        "get",
                        "worldview"
                    ],
                    [
                        "all",
                        "US"
                    ],
                    true,
                    false
                ],
                "disputed_state",
                [
                    "all",
                    [
                        "==",
                        [
                            "get",
                            "disputed"
                        ],
                        "true"
                    ],
                    [
                        "match",
                        [
                            "get",
                            "worldview"
                        ],
                        [
                            "all",
                            "US"
                        ],
                        true,
                        false
                    ]
                ],
                false
            ],
            "type": "symbol",
            "source": "composite",
            "id": "state-label",
            "paint": {
                "text-color": "hsl(230, 29%, 0%)",
                "text-halo-color": "hsl(35, 16%, 100%)",
                "text-halo-width": 1
            },
            "source-layer": "place_label"
        },
        {
            "minzoom": 1,
            "layout": {
                "icon-image": "",
                "text-field": [
                    "coalesce",
                    [
                        "get",
                        "name_en"
                    ],
                    [
                        "get",
                        "name"
                    ]
                ],
                "text-line-height": 1.1,
                "text-max-width": 6,
                "text-font": [
                    "DIN Pro Medium",
                    "Arial Unicode MS Regular"
                ],
                "text-offset": [
                    "literal",
                    [
                        0,
                        0
                    ]
                ],
                "text-justify": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "match",
                        [
                            "get",
                            "text_anchor"
                        ],
                        [
                            "left",
                            "bottom-left",
                            "top-left"
                        ],
                        "left",
                        [
                            "right",
                            "bottom-right",
                            "top-right"
                        ],
                        "right",
                        "center"
                    ],
                    7,
                    "center"
                ],
                "text-size": [
                    "interpolate",
                    [
                        "cubic-bezier",
                        0.2,
                        0,
                        0.7,
                        1
                    ],
                    [
                        "zoom"
                    ],
                    1,
                    [
                        "step",
                        [
                            "get",
                            "symbolrank"
                        ],
                        13.2,
                        4,
                        10.799999999999999,
                        5,
                        9.6
                    ],
                    9,
                    [
                        "step",
                        [
                            "get",
                            "symbolrank"
                        ],
                        33.6,
                        4,
                        26.4,
                        5,
                        25.2
                    ]
                ]
            },
            "metadata": {
                "mapbox:featureComponent": "place-labels",
                "mapbox:group": "Place labels, place-labels"
            },
            "maxzoom": 10,
            "filter": [
                "match",
                [
                    "get",
                    "class"
                ],
                "country",
                [
                    "match",
                    [
                        "get",
                        "worldview"
                    ],
                    [
                        "all",
                        "US"
                    ],
                    true,
                    false
                ],
                "disputed_country",
                [
                    "all",
                    [
                        "==",
                        [
                            "get",
                            "disputed"
                        ],
                        "true"
                    ],
                    [
                        "match",
                        [
                            "get",
                            "worldview"
                        ],
                        [
                            "all",
                            "US"
                        ],
                        true,
                        false
                    ]
                ],
                false
            ],
            "type": "symbol",
            "source": "composite",
            "id": "country-label",
            "paint": {
                "icon-opacity": [
                    "step",
                    [
                        "zoom"
                    ],
                    [
                        "case",
                        [
                            "has",
                            "text_anchor"
                        ],
                        1,
                        0
                    ],
                    7,
                    0
                ],
                "text-color": "hsl(230, 29%, 0%)",
                "text-halo-color": [
                    "interpolate",
                    [
                        "linear"
                    ],
                    [
                        "zoom"
                    ],
                    2,
                    "hsla(35, 16%, 100%, 0.75)",
                    3,
                    "hsl(35, 16%, 100%)"
                ],
                "text-halo-width": 1.25
            },
            "source-layer": "place_label"
        }
    ],
    "created": "2020-09-20T19:52:22.937Z",
    "modified": "2020-09-20T21:04:18.400Z",
    "id": "ckfbioyul1iln1ap0pm5hrcgy",
    "owner": "xennis",
    "visibility": "private",
    "protected": false,
    "draft": false
}''';
