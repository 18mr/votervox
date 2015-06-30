---
layout: page
title: Blog
permalink: /blog/
---

<ul class="posts">
	{% for post in site.posts %}
		{% if post.featured-image %}
			<li class="featured-img">
				<img class="thumbnail" src="{{ post.featured-image }}">
				<h2>
					<a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
				</h2>
				<span>{{ post.blurb | truncatewords: 50, '...' }} <a href="{{ post.url | prepend: site.baseurl }}">Read More</a></span>
			</li>
		{% else %}
			<li class="no-img">
				<h2>
					<a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
				</h2>
				<span>{{ post.blurb | truncatewords: 100, '...' }} <a href="{{ post.url | prepend: site.baseurl }}">Read More</a></span>
			</li>
		{% endif %}
	{% endfor %}
</ul>