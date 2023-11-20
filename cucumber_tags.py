"""
Author: Anh Tran

This python script is used to update priority for feature files from Cucumber Studio.

How to run:
- Install python3
- pip3 install requests
- python3 cucumber_tags.py
"""


import re, requests, os

url = 'https://studio.cucumber.io/api'
project_id = 208144
access_token = 'XGZp_Ih50Ry2BDGWVsAqJQ'
client = 'ZOLHWUo1NIc9cSPPHmiPnA'
uid = 'rizaq.pratama@ninjavan.co'

headers = {
    'Accept': 'application/vnd.api+json; version=1',
    'access-token': access_token,
    'client': client,
    'uid': uid
}

def extract_scenarios(json):
    return [item['attributes']['name'] for item in json['data']]

def get_scenarios_by_tags(tag):
    response = requests.get(f"{url}/projects/{project_id}/scenarios/find_by_tags?key=priority&value={tag}", headers=headers)
    return extract_scenarios(response.json())

def fetch_scenarios():
    print("Start fetching scenarios from Cucumber Studio...")
    # Get high priority scenarios
    global high_scenarios
    high_scenarios = get_scenarios_by_tags('high')

    # Get medium priority scenarios
    global medium_scenarios
    medium_scenarios = get_scenarios_by_tags('medium')

    # Get high priority scenarios
    global low_scenarios
    low_scenarios = get_scenarios_by_tags('low')

    print("From Cucumber Studio, you have:")
    print(f"- High priority scenarios: {len(high_scenarios)}")
    print(f"- Medium priority scenarios: {len(medium_scenarios)}")
    print(f"- Low priority scenarios: {len(medium_scenarios)}")

def get_tag(scenario):
    if scenario in high_scenarios:
        return '@HighPriority'
    elif scenario in medium_scenarios:
        return '@MediumPriority'
    elif scenario in low_scenarios:
        return '@LowPriority'
    else:
        return ''

def update_priority_tag(tag, cucumber_tag):
    new_tag = tag.rstrip()
    new_tag = new_tag.replace('@HighPriority', cucumber_tag)
    new_tag = new_tag.replace('@MediumPriority', cucumber_tag)
    new_tag = new_tag.replace('@LowPriority', cucumber_tag)
    if new_tag.find(cucumber_tag) == -1:
        new_tag = new_tag + ' ' + cucumber_tag
    return new_tag

def check_priority_tag(tag):
    if tag.find('@HighPriority') >= 0 or tag.find('@MediumPriority') >= 0 or tag.find('@LowPriority') >= 0:
        return True
    else:
        return False

def remove_priority_tag(tag):
    new_tag = tag.replace('@HighPriority', '')
    new_tag = new_tag.replace('@MediumPriority', '')
    new_tag = new_tag.replace('@LowPriority', '')
    return new_tag

def check_features():
    print("Scan feature files to update priority from Cucumber Studio...")
    print("Cannot find priority tag for scenarios below:")
    missed = 0
    high_count = 0
    medium_count = 0
    low_count = 0
    csv_data = 'path,line,col\n'
    for path, dirs, files in os.walk("src"):
        for filename in files:
            if filename.endswith(".feature"):
                fullpath = os.path.join(path, filename)
                with open(fullpath, 'r') as f:
                    lines = f.readlines()
                i = 0
                scenario = ''
                partial_scenario = ''
                template = ''
                outline = False
                examples = False
                get_column_name = False
                get_example_data = False
                end_example = False
                while i < len(lines):
                    if 'Scenario:' in lines[i]:
                        scenario = lines[i].replace('Scenario:', '').strip()
                        index = i
                        outline = False
                    elif 'Scenario Outline:' in lines[i]:
                        scenario = lines[i].replace('Scenario Outline:', '').strip()
                        template = scenario
                        if re.findall(' - <.*>', scenario):
                            partial_scenario = re.sub(' - <.*>', '', scenario)
                        outline = True
                        index = i
                    if outline == True and 'Examples:' in lines[i]:
                        examples = True
                        get_column_name = False
                        end_example = False
                    elif examples == True and lines[i].count('|') >= 2:
                        if get_column_name == False:
                            column_names = [value.strip() for value in lines[i].split('|') if value.strip()]
                            get_column_name = True
                        elif end_example == False:
                            values = [value.strip() for value in lines[i].split('|') if value.strip()]
                            row = dict(zip(column_names, values))
                            scenario = template
                            for key, value in row.items():
                                scenario = scenario.replace(f"<{key}>", value).strip()
                            get_example_data = True
                    elif examples == True and lines[i].count('|') < 2:
                        end_example = True
                    if scenario != '' and ((outline == False) or (outline == True and get_example_data == True)):
                        cucumber_tag = get_tag(scenario)
                        if cucumber_tag == '' and partial_scenario != '':
                            cucumber_tag = get_tag(partial_scenario)
                        if cucumber_tag != '':
                            if ('@' in lines[index-1]):
                                lines[index-1] = update_priority_tag(lines[index-1], cucumber_tag) + '\n'
                            else:
                                lines.insert(index, ' ' * lines[index].find('Scenario') + cucumber_tag + '\n')
                                i += 1
                            if cucumber_tag == '@HighPriority':
                                high_count += 1
                            elif cucumber_tag == '@MediumPriority':
                                medium_count += 1
                            elif cucumber_tag == '@LowPriority':
                                low_count += 1
                            if outline == True:
                                end_example = True
                        else:
                            if not check_priority_tag(lines[index-1]):
                                if outline == False or (outline == True and end_example == True):
                                    missed += 1
                                    print(f"file://{fullpath}:{index+1}:{lines[index].find('Scenario') + 1}")
                                    csv_data = csv_data + f"{fullpath},{index+1},{lines[index].find('Scenario') + 1}\n"
                            else:
                                lines[index-1] = remove_priority_tag(lines[index-1])
                        if outline == False or (outline == True and end_example == True):
                            scenario = ''
                            partial_scenario = ''
                            template = ''
                            outline = False
                            examples = False
                            get_column_name = False
                            get_example_data = False
                    i += 1
                with open(fullpath, 'w') as f:
                    f.writelines(lines)
                with open('missed_scenarios.csv', 'w') as f:
                    f.write(csv_data)
    if not missed:
        print("- None")
    print("Completed! Double check your changed files if needed.")
    print("Update summary:")
    print(f"- High priority scenarios: {high_count}")
    print(f"- Medium priority scenarios: {medium_count}")
    print(f"- Low priority scenarios: {low_count}")
    print(f"- Missed priority tag scenarios: {missed}")
    print("Missed scenarios logged in missed_scenarios.csv")

def main():
    fetch_scenarios()
    check_features()

if __name__ == "__main__":
    main()