from django.db import models
from django.contrib.auth.models import User

class Problem(models.Model):
    name = models.CharField(max_length=50)
    def __str__(self):
        return self.name

class Catagory(models.Model):
    name = models.CharField(max_length=50)
    problem = models.ForeignKey(Problem,on_delete=models.CASCADE)
    t_score_lower = models.FloatField(default=0)
    t_score_upper = models.FloatField(default=0)

    def __str__(self):
        return str(self.problem)+ '_' + self.name

class Score(models.Model):
    problem = models.ForeignKey(Problem,on_delete=models.CASCADE)
    raw_score = models.FloatField(default=0)
    t_score = models.FloatField(default=0)

    def __str__(self):
        return str(self.problem)+ '_' + str(self.id)

class Question(models.Model):
    question = models.CharField(max_length=200)
    problem = models.ForeignKey(Problem,on_delete=models.CASCADE)
    def __str__(self):
        return str(self.problem)+ '_question_' + str(self.id)

class Response(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    question = models.ForeignKey(Question,on_delete=models.CASCADE)
    score = models.FloatField(default=0)
