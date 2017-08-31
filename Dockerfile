# Example usage:
#
#  $ docker run -i foo < policy.json
# 
FROM ruby:slim

ADD iam2tf.rb /usr/local/bin/iam2tf

CMD iam2tf
