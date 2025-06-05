#!/bin/bash

# 변경된 HTML 파일 목록 가져오기
changed_files=$(git status -s | grep "\.html$" | awk '{print $2}')

# 커밋 여부를 추적하는 변수
commits_made=0

# 각 HTML 파일에 대해 처리
for file in $changed_files; do
  if [ -f "$file" ]; then
    # title 태그 내용 추출
    title=$(grep -o "<title>.*</title>" "$file" | sed 's/<title>\(.*\)<\/title>/\1/')
    
    # "| 컨트롤 + CCCV" 부분 제거
    clean_title=$(echo "$title" | sed 's/ | 컨트롤 + CCCV//')
    
    if [ -n "$clean_title" ]; then
      # 파일 스테이징
      git add "$file"
      
      # 수정된 title 내용으로 커밋
      git commit -m "$clean_title"
      
      echo "커밋 완료: $file - '$clean_title'"
      commits_made=1
    else
      echo "경고: $file에서 title 태그를 찾을 수 없습니다."
    fi
  fi
done

# 변경사항이 있으면 푸시
if [ $commits_made -eq 1 ]; then
  echo "GitHub에 변경사항 푸시 중..."
  git push origin main
  echo "푸시 완료!"
else
  echo "커밋할 변경사항이 없습니다."
fi 