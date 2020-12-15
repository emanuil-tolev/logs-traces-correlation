from flask import Flask
from elasticapm.contrib.flask import ElasticAPM
import logging
import requests
import structlog

from supermarket.config import config

app = Flask(__name__)
app.config.update(config)

apm = ElasticAPM(app)

from structlog import PrintLogger, wrap_logger
from structlog.processors import JSONRenderer
from elasticapm.handlers.structlog import structlog_processor as apm_structlog_processor

def rename_event_key(logger, method_name, event_dict):
    event_dict["message"] = event_dict.pop("event")
    return event_dict

f = open('supermarket.log', 'w')

wrapped_logger = PrintLogger(file=f)
logger = wrap_logger(wrapped_logger, processors=[

        apm_structlog_processor,
        rename_event_key,

        structlog.processors.TimeStamper(fmt="%Y-%m-%d %H:%M:%S"),
        structlog.stdlib.add_log_level, structlog.processors.format_exc_info, JSONRenderer()
    ])
log = logger.new()

@app.route('/')
def hello_world():
    x = 3
    y = 42
    log.info(
        'About to call another internal service, requesting info on surplus of goods {}, {}'.format(x,y),
        x=x, y=y)
    r = call_another_internal_service(x, y)
    log.info('Surplus information obtained: {}'.format(r.text))
    return 'Single-file Supermarket Management System'

def call_another_internal_service(x, y):
    return requests.get('http://localhost:3000/?x={}&y={}'.format(x, y))
