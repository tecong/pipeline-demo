(function() {
    'use strict';

    angular
        .module('demoappApp')
        .factory('ProductSearch', ProductSearch);

    ProductSearch.$inject = ['$resource'];

    function ProductSearch($resource) {
        var resourceUrl =  'repository/' + 'api/_search/products/:id';

        return $resource(resourceUrl, {}, {
            'query': { method: 'GET', isArray: true}
        });
    }
})();
