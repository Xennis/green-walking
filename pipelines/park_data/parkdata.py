import logging

from greenwalking.pipeline.places import run

if __name__ == "__main__":
    logging.getLogger().setLevel(logging.INFO)
    run()
