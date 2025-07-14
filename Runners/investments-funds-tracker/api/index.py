import json
import time

from http.server import BaseHTTPRequestHandler
from utils.db import insert_investment_data
from utils.genai_module import get_investment_info
from utils.news_module import get_today_news_urls
from utils.redis_db import has_processed_link, mark_link_as_processed

from utils.config import CRON_SECRET

import outputformat as ouf

class handler(BaseHTTPRequestHandler):

    def send_response_with_data(self, status_code, content_type, data):
        """Helper function to send a response with the given data."""
        self.send_response(status_code)
        self.send_header('Content-type', content_type)
        self.end_headers()
        self.wfile.write(data.encode('utf-8'))

    def send_error_response(self, status_code, message):
        """Helper function to send an error response."""
        self.send_response(status_code)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(message.encode('utf-8'))

    def check_authorization(self):
        """Check the Authorization header against the expected token."""
        token = CRON_SECRET
        if self.headers.get('Authorization') != f'Bearer {token}':
            self.send_error_response(403, f"Forbidden: Invalid Authorization token.{token}")
            return False
        return True

    def do_GET(self):
        """Handle the GET request."""
        # print("Hi")
        # if not self.check_authorization():
        #     return  # Early exit if authorization fails

        try:
            count = 0
            COUNT_TO_EXIT = 10
            all_data = []
            news_urls = []
            error_links = []
            return_data = {'error' : False, 'message': 'Done', 'data': all_data, 'news_urls': news_urls}

            news_urls = get_today_news_urls()
            total_len = len(news_urls)
            bar_count = 0
            print("Total Fetched URLs: " + str(total_len))

            if (news_urls is None) or (total_len <= 0):
                return_data['error'] = True
                return_data['message'] = "news_urls is None or 0. Check Logs"

            news_urls.reverse()

            for news_url in news_urls:
                print("Processing: " + news_url)
                bar_count = bar_count + 1

                if has_processed_link(news_url):
                    print("Link is already processed: " + news_url)
                    continue

                ai_parsed_dict = get_investment_info(news_url)
                if ai_parsed_dict is None:
                    return_data['error'] = True
                    return_data['message'] = "ai_parsed_dict is None. Check Logs"
                    error_links.append(news_url)
                    # break
                insert_data = True
                if ai_parsed_dict["funding_related"]:
                    print("Trying to insert: " + news_url)
                    try:
                        insert_data = insert_investment_data(ai_parsed_dict)
                    except Exception as inner_e:
                        print(inner_e)

                all_data.append(ai_parsed_dict)
                if insert_data:
                    mark_link_as_processed(news_url)

                # Exit to slowly process the information
                if count == COUNT_TO_EXIT:
                    break
                else:
                    count = count + 1
                ouf.bar(bar_count, total_len)
                time.sleep(2.5)
            print("Got: " + str(len(news_urls)))
            # Send the successful response
            return_data['data'] = all_data
            return_data['news_urls'] = news_urls
            if return_data['error']:
                self.send_error_response(500, 'application/json', json.dumps(return_data))
            else:
                self.send_response_with_data(200, 'application/json', json.dumps(return_data))

        except Exception as e:
            # Handle any errors
            self.send_error_response(500, f"Error: {e}")
