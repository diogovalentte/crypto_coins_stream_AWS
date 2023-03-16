import os
import json
import boto3
import requests as r
from datetime import datetime


def lambda_handler(event, context):
    """Resquest data of 10 coins to an API and put the data on a AWS Kinesis Firehose stream.

    Args:
        event: Lambda event.
        context: Lambda context.

    Returns:
        dict: Boto3 Firehose client response from put_record method.
    """
    BASE_URL = "https://www.mercadobitcoin.net/api/"
    tickers = [
        "BTC",
        "ETH",
        "USDC",
        "XRP",
        "WLUNA",
        "ADA",
        "SOL",
        "AVAX",
        "UNI",
        "DOGE",
    ]
    request_method = "ticker"

    responses = {"collected_tstamp": str(datetime.now()), "coins": {}}
    for coin in tickers:
        response = r.get(BASE_URL + f"{coin}/{request_method}/")
        response = response.json()
        responses["coins"][coin] = response["ticker"]

    payload = json.dumps(responses)
    payload = payload + "\n"

    firehose = boto3.client("firehose")
    kinesis_response = firehose.put_record(
        DeliveryStreamName=os.environ.get("DeliveryStreamName"),
        Record={"Data": payload},
    )

    return kinesis_response
