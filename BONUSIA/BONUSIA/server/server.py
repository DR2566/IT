from aiohttp import web
import aiohttp_cors
import requests
from database import *
import asyncio
from database import *


# ------------------------------------------------      REST API server           -----------------------------------------------------

routes = web.RouteTableDef()

@routes.post('/this-is-post')
async def this_is_post(request):
    
    try:
        # get data from APC
        data = await request.json()
        
        # send the response to the APC
        result = {
            "Result":"fst is oke"
        }
        return web.json_response(result, status=200)
    except Exception as e:
        # send the response to the APC
        result = {
            "Result":str(e)
        }
        return web.json_response(result, status=500)


@routes.get('/this-is-get')
async def this_is_get(request):
    
    try:
        
        param = int(request.query.get('param'))

        result = {
            "Result":"snd is oke"
        }
        
        return web.json_response(result, status=200)
    
    except Exception as e:
        result = {
            "Result": str(e)
        }
        
        return web.json_response(result, status=500)


app = web.Application()

# Setup CORS
cors = aiohttp_cors.setup(app, defaults={
    "*": aiohttp_cors.ResourceOptions(
        allow_credentials=True,
        expose_headers="*",
        allow_headers="*",
    )
})

# Add routes to the application
app.add_routes(routes)

# Add CORS to each route
for route in list(app.router.routes()):
    cors.add(route)

async def start_http_server():

    runner = web.AppRunner(app)
    await runner.setup()
    site = web.TCPSite(runner, "0.0.0.0", 7676)
    await site.start()
    print("HTTP server started :-)")

async def main():
    await asyncio.gather(start_http_server())

if __name__ == '__main__':
    asyncio.run(main())
