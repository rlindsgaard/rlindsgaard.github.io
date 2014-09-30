---
title: Blog
layout: page
---
{% include JB/setup %}

<div class="posts">
{% for post in site.posts limit: 5 %}
  <div class="post row">
    <h1><a href="{{ post.url }}">{{ post.title }}</a><small>{{ post.date | date:"%Y-%m-%d" }}</small></h3>
    <div class="content">
      {{ post.content }}
    </div>
  </div>
{% endfor %}
</div>