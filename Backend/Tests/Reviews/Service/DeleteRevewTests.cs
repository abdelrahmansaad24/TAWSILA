﻿using Backend.Models.Exceptions;
using Backend.Repositories;
using Backend.Services;

namespace Tests.Reviews.Service
{
    public class DeleteRevewTests
    {
        [Fact]
        public async void DeleteReviewTest_ReturnsSuccess()
        {
            // Arrange 
            int reviewId = 1, userId = 1;
            var mockRepo = new Mock<IReviewRepo>();
            var mockUserService = new Mock<IUserService>();
            var review = ReviewHelper.GetTestReview(1);
            mockRepo.Setup(x => x.GetReview(review.Id)).ReturnsAsync(review);
            mockRepo.Setup(x => x.DeleteReview(review.Id));
            var reviewService = new ReviewService(mockRepo.Object);

            // Act
            var result = await Record.ExceptionAsync(async () => await reviewService.DeleteReview(userId, reviewId));

            // Assert
            Assert.Null(result);
        }

        [Fact]
        public void DeleteNonExistentReviewTest_ReturnsUnauthorized()
        {
            // Arrange 
            int reivewId = 1, userId = 1;
            var mockRepo = new Mock<IReviewRepo>();
            var mockUserService = new Mock<IUserService>();
            var review = ReviewHelper.GetTestReview(reivewId);
            mockRepo.Setup(x => x.GetReview(review.Id)).Throws(new NotFoundException("Review not found"));
            mockRepo.Setup(x => x.DeleteReview(review.Id));
            var reviewService = new ReviewService(mockRepo.Object);

            // Act
            var result = async () => await reviewService.DeleteReview(userId, reivewId);

            // Assert
            UnauthorizedException exception = Assert.ThrowsAsync<UnauthorizedException>(result).Result; ;
        }

        [Fact]
        public void DeleteReviewTest_ReturnsUnauthorized()
        {
            // Arrange 
            int reivewId = 1, userId = 1;
            var mockRepo = new Mock<IReviewRepo>();
            var mockUserService = new Mock<IUserService>();
            var review = ReviewHelper.GetTestReview(reivewId);
            mockRepo.Setup(x => x.GetReview(review.Id)).ReturnsAsync(review);
            mockRepo.Setup(x => x.DeleteReview(review.Id)).ThrowsAsync(new UnauthorizedException("You can only Delete your reviews")); ;
            var reviewService = new ReviewService(mockRepo.Object);

            // Act
            var result = async () => await reviewService.DeleteReview(userId, reivewId);

            // Assert
            UnauthorizedException exception = Assert.ThrowsAsync<UnauthorizedException>(result).Result; ;
        }

    }
}
