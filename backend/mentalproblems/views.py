from rest_framework.decorators import api_view
from django.http import JsonResponse
from django.contrib.auth.decorators import login_required
import json

# function based views


@api_view(['GET'])
def sample_get(request):
    if request.method == 'GET':
        content = {
            'user': str(request.user),
        }
        if(content['user'] == 'AnonymousUser'):
            return JsonResponse({'status': 401, 'message': 'Not Authenicated'})
        else:
            return JsonResponse(content)
    else:
        return JsonResponse({'error': 'Only GET method is allowed'})


@api_view(['POST'])
def sample_post(request):
    if request.method == 'POST':
        content = request.data
        return JsonResponse(content, safe=False)
    else:
        return JsonResponse({'error': 'Only POST method is allowed'})


# we have to use oauth for OAuth2
