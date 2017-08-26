#!/usr/bin/env ruby

require "erb"
require "json"

doc = JSON.parse(STDIN.read)

def s(s)
  s.inspect
end

def a(a, indent = 0)
  [*a].map(&:inspect).join(",\n#{' ' * indent}")
end

class Statement
  attr_accessor :sid, :effect, :actions, :resources, :conditions, :principals,
                :not_actions, :not_resources, :not_principals

  def initialize(s)
    self.sid       = s["Sid"]
    self.effect    = s["Effect"]

    self.actions    = [*s["Action"]]
    self.resources  = [*s["Resource"]]
    self.principals = [*s["Principal"]].map { |p| Principal.new p }

    self.not_actions    = [*s["NotAction"]]
    self.not_resources  = [*s["NotResource"]]
    self.not_principals = [*s["NotPrincipal"]].map { |p| Principal.new p }

    self.conditions = (s["Condition"] || {}).map { |(c,kv)| Condition.new c,kv }
  end
end

class Condition
  attr_accessor :test, :variable, :values

  def initialize(type, key_values)
    self.test = type
    self.variable, *self.values = [*key_values].flatten
  end
end

class Principal
  attr_accessor :type, :identifiers

  def initialize(p)
    self.type, self.identifiers = * (p == "*" ? %w[* *] : p)
  end
end

policy_id  = doc["Id"]
statements = doc["Statement"].map { |s| Statement.new(s) }

pp statements if $DEBUG

puts ERB.new(DATA.read, nil, "<>").result(binding).gsub(/\n\n+/, "\n\n")

__END__
data "aws_iam_policy_document" "iam2tf" {

<% if policy_id %>
  policy_id = <%= s(policy_id) %>
<% end %>

<% statements.each do |statement| %>
  statement {
<% if statement.sid %>
    sid    = <%= s(statement.sid) %>
<% end %>
<% if statement.effect %>
    effect = <%= s(statement.effect) %>
<% end %>

<% unless statement.actions.empty? %>
    actions = [
      <%= a(statement.actions, 6) %>
    ]
<% end %>

<% unless statement.not_actions.empty? %>
    not_actions = [
      <%= a(statement.not_actions, 6) %>
    ]
<% end %>

<% unless statement.resources.empty? %>
    resources = [
      <%= a(statement.resources, 6) %>
    ]
<% end %>

<% unless statement.not_resources.empty? %>
    not_resources = [
      <%= a(statement.not_resources, 6) %>
    ]
<% end %>

<% statement.conditions.each do |condition| %>
    condition {
      test     = <%= s(condition.test) %>
      variable = <%= s(condition.variable) %>

      values = [
        <%= a(condition.values, 8) %>
      ]
    }

<% end %>

<% statement.principals.each do |principal| %>
    principals {
      type = <%= s(principal.type) %>

      identifiers = [
        <%= a(principal.identifiers, 8) %>
      ]
    }

<% end %>

<% statement.not_principals.each do |principal| %>
    not_principals {
      type = <%= s(principal.type) %>

      identifiers = [
        <%= a(principal.identifiers, 8) %>
      ]
    }

<% end %>
  }

<% end %>
}
