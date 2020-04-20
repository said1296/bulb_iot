from django.middleware.csrf import get_token

class SetCsrf:

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        if 'x-csrftoken' not in request.headers and request.method=='GET':
            get_token(request)
        response = self.get_response(request)
        return response