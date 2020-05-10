from django.contrib import admin
from .models import Problem,Catagory,Score,Question,Response

# Register your models here.
admin.site.register(Problem)
admin.site.register(Catagory)
admin.site.register(Score)
admin.site.register(Question)
admin.site.register(Response)