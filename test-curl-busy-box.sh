for i in $(seq 1 10000)
do
  curl a40d77ec4eb32425a969325f2febc3fc-146084843.us-west-1.elb.amazonaws.com > test.txt
done
