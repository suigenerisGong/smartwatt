import logging

FATAL = logging.FATAL
CRITICAL = logging.CRITICAL
ERROR = logging.ERROR
WARNING = logging.WARNING
INFO = logging.INFO
DEBUG = logging.DEBUG

def init_logger(level=INFO,log_file=""):
    logger = logging.getLogger(__name__)
    logger.setLevel(level = level)
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')

    if log_file:
        
        handler = logging.FileHandler(log_file)
        handler.setLevel(level)
        handler.setFormatter(formatter)
        
        console = logging.StreamHandler()
        console.setLevel(level)
        console.setFormatter(formatter)
        
        logger.addHandler(handler)
        logger.addHandler(console)

    else:
        console = logging.StreamHandler()
        console.setLevel(level)
        console.setFormatter(formatter)
        
        logger.addHandler(console)
        
    return logger

if __name__ == "__main__":
    
    logger = init_logger()
    logger.info("Start print log")
    logger.debug("Do something")
    logger.warning("Something maybe fail.")
    logger.error("erorr happened")
    logger.info("Finish")
