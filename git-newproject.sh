#!/usr/bin/env bash
# ���ϵ���Ŀ�������ύ���µ�GIT�ֿ�
CIVET_MANAGE_DIR='D:\Workspace\old-project'
SWEET_MANAGE='D:\Workspace\new-project'

GIT_URL_PREFIX=http://192.168.18.14:81/sweet

function fun_git_branch() {
  br=`git branch | grep "*"`
  echo ${br/* /}
}

function fun_branch() {
    if [[ $1 == *"-api" ]];
    then
        echo "dev"
    else
        echo "master"
    fi
}

cd $CIVET_MANAGE_DIR
for civetModule in `ls .`
do
    if [[ $civetModule =~ 'base' ]];
    then
        echo '��������'$civetModule
    else
        echo '����ԴĿ¼'$civetModule'���zip'
        cd $CIVET_MANAGE_DIR'/'$civetModule
        curBranch=`fun_git_branch`
        pullBranch=`fun_branch $civetModule`
        echo '��ǰ��֧'$curBranch'�л���'$pullBranch

        outZip=source.zip
        if [[ $curBranch != $pullBranch ]];
        then
            git checkout $pullBranch
            git pull
            git archive --output=$outZip --format=zip $pullBranch -0
            echo '�����֧'$pullBranch'zip�����'
            echo '�лط�֧'$curBranch
            git checkout $curBranch
        else
            git archive --output=$outZip --format=zip $pullBranch -0
        fi

        echo '����Ŀ��Ŀ¼, ��ѹzip��push'
        cd $SWEET_MANAGE

        sweetModule=sweet-$civetModule
        mkdir $sweetModule
        cd $sweetModule
        unzip $CIVET_MANAGE_DIR'/'$civetModule'/'$outZip -d .
        git init
        git remote add origin $GIT_URL_PREFIX'/'$sweetModule
        git add .
    #    git commit -a -m 'first commit'
    #    git push --set-upstream origin $sweetModule
    #    git pull
    fi
done

