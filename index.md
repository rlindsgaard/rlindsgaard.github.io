---
layout: page
---
{% include JB/setup %}

<div class="posts">
{% for post in site.posts limit: 5 %}
  <div class="post row">
    <h3><a href="{{ post.url }}">{{ post.title }}</a></h3>
    <span>({{ post.date | date:"%Y-%m-%d" }})</span>
    <div class="content">
      {{ post.content }}
    </div>
  {% endfor %}
</div>