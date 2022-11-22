#!/bin/bash

set -e

sed -i "s#GET_HANDLER_SUPPORT=\"archive\"#GET_HANDLER_SUPPORT=\"archive git\"#" distributions/LibreELEC/options