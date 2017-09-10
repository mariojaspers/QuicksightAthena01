# Part 4 - Visualizing Data with QuickSight

## References

1. [Managing Amazon QuickSight Permissions](http://docs.aws.amazon.com/quicksight/latest/user/managing-permissions.html)
2. [Creating Datasets using Amazon Athena](http://docs.aws.amazon.com/quicksight/latest/user/create-a-data-set-athena.html)

## Setting up permissions

Amazon QuickSight manages its own set of users and therefore you need to have an administrator account that is allowed to create new users.
We'll use your current user as the administrator and therefore we'll need to add additional permissions for it to do its job.

1. Open the IAM console
2. Add the following managed policies
  - IAMFullAccess

QuickSight does not have a managed policy so we'll need to create one and then associate it with our user.

1. On the same screen where you added permissions in the previous step, click the Create Policy button
2. Select **Create Your Own Policy**
3. Name your policy **QuicksightPolicy** and enter the following into the **Policy Document** text box

```
{
    "Statement": [
        {
            "Action": [
                "quicksight:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ],
    "Version": "2012-10-17"
}
```

1. Once created, select your username again from the **Users** section and add permissions as you've done previously.  Search for **QuicksightPolicy** and add it.

## Connecting with Amazon QuickSight

To explore the Instacart data we previously created we need to login to Amazon QuickSight and create a data set directly from Amazon Athena.

1. Open the QuickSight console
2. If it's your first time you'll be asked to enter an email address to create an account.  If you've accessed QuickSight before you'll land in the main window

1. Click the **New Analysis** button at the top left of the screen
2. Click **New Data Set** and select **Athena** from the list of sources

1. Give your data source a name and click **Create data source**
2. Select the **Instacart** database we created in Part 3 of this lab
3. Select the `table_prior_orders` as a starting point for us to explore

1. Select to **Directly query your data** and click **Visualize**

At this point you are presented with a blank graph so feel free to play around and build interesting visualizations.

For example, here is a graph of the count of customer orders that include items from each department

Here is another example of the top purchased products by the total number of customer orders
